# all about fetching the data from the api and feeding it within the mongodb instance


using Pkg;
Pkg.add(["DotEnv", "HTTP", "JSON", "Mongoc", "CSV", "DataFrames"]);

using DotEnv, HTTP, JSON, CSV, Mongoc, DataFrames;
# using Dates;
# page page_title active_visitors

#configuring environment variables
DotEnv.config();


#global vars
UPLOAD_DATA_TO_MONGODB = true;


#############################################################################

#OBJECT ORIENTED PROGRAMMING BEGINS

#               environment variables structures
struct Environment_variable_struct
    env_var_instance::String
end

get_environment_variables(object::Environment_variable_struct, env_variable_array::Vector{String}) = begin
    environment_variable_dict_array::Vector{Dict{String,Any}} = Vector{Dict{String,Any}}()
    for env_var_name in env_variable_array
        push!(environment_variable_dict_array, Dict(env_var_name => ENV[env_var_name]))
    end
    return environment_variable_dict_array
end






#       agency names structure
struct Initialise_agency_names_array
    agency_names_array::Vector{String}
end

lowercase_agency_names(object::Initialise_agency_names_array) = begin
    agency_names_array::Vector{String} = object.agency_names_array
    lowercased_agency_names_array::Vector{String} = Vector{String}()
    for agency_name in agency_names_array
        push!(lowercased_agency_names_array, lowercase(agency_name))
    end
    return lowercased_agency_names_array
end

uppercase_agency_names(object::Initialise_agency_names_array) = begin
    agency_names_array::Vector{String} = object.agency_names_array
    uppercased_agency_names_array::Vector{String} = Vector{String}()
    for agency_name in agency_names_array
        push!(uppercased_agency_names_array, uppercase(agency_name))
    end
    return uppercased_agency_names_array
end

capitalise_agency_names(object::Initialise_agency_names_array) = begin
    agency_names_array::Vector{String} = object.agency_names_array
    capitalised_agency_names_array::Vector{String} = Vector{String}()
    for agency_name in agency_names_array
        push!(capitalised_agency_names_array, uppercasefirst(agency_name))
    end
    return capitalised_agency_names_array
end







#       report names structure
struct Initialise_report_names_array
    report_names_array::Vector{String}
end

lowercase_report_names(object::Initialise_report_names_array) = begin
    report_names_array::Vector{String} = object.report_names_array
    lowercased_report_names::Vector{String} = Vector{String}()
    for report_name in report_names_array
        push!(lowercased_report_names, lowercase(report_name))
    end
    return lowercased_report_names
end


filter_report_names_array_to_include_site_and_download(object::Initialise_report_names_array, lowercased_report_names_array::Vector{String}) = begin
    report_names_array::Vector{String} = lowercased_report_names_array
    array_is_ideal(report) = report in ["site", "download"]
    report_names_array = filter(array_is_ideal, report_names_array)

    return report_names_array
end

filter_report_names_array_to_include_everything_except_site_and_download(object::Initialise_report_names_array, lowercased_report_names_array::Vector{String}) = begin
    report_names_array::Vector{String} = lowercased_report_names_array
    array_is_ideal(report) = !(report in ["site", "download"])
    report_names_array = filter(array_is_ideal, report_names_array)

    return report_names_array
end







#       data fetch from api and urls
mutable struct Fetch_data
    data_from_api_array::Vector{Dict{String,Any}}
    data_from_http_array::Vector{Dict{String,Any}}
    usa_gov_api_key::String
end


#setting and manipulating urls for fetching data {involved with Fetch_data struct}
format_url_for_api(object::Fetch_data, agency_name::String, report_name::String) = begin
    base_url::String = ""
    if lowercase(agency_name) == "all"
        base_url = "https://api.gsa.gov/analytics/dap/v1.1/reports/$report_name/data"
    else
        base_url = "https://api.gsa.gov/analytics/dap/v1.1/agencies/$agency_name/reports/$report_name/data"
    end
    return base_url
end

format_url_for_http(object::Fetch_data, agency_name::String, report_name::String) = begin
    #this function does not deal with site and download reports
    #formatting list of reports to remove site and download
    base_url::String = ""

    if lowercase(agency_name) == "all"
        base_url = "https://analytics.usa.gov/data/live/$report_name"
    else
        base_url = "https://analytics.usa.gov/data/$agency_name/$report_name"
    end
    return base_url
end




#call this function if Fetch_data.method == "api"
data_from_api(object::Fetch_data, object_two::Initialise_agency_names_array, object_three::Initialise_report_names_array) = begin
    master_string_data_blob_array::Vector{Dict{String,Any}} = []
    lowercased_report_names_array = lowercase_report_names(object_three)
    list_of_agencies::Vector{String} = lowercase_agency_names(object_two)
    list_of_reports::Vector{String} = filter_report_names_array_to_include_site_and_download(object_three, lowercased_report_names_array)
    usagov_api_key::String = object.usa_gov_api_key
    http_headers_for_api_request::Dict{String,String} = Dict("x-api-key" => usagov_api_key)
    base_url::String = ""
    for agency_name in list_of_agencies
        agency_report_string_data_dict::Dict{String,Any} = Dict()
        for report_name in list_of_reports
            base_url = format_url_for_api(object, agency_name, report_name)
            println(base_url)
            response = HTTP.request("GET", base_url, http_headers_for_api_request)
            stringified_http_response = String(response.body)
            agency_report_string_data_dict[report_name] = stringified_http_response
        end
        push!(master_string_data_blob_array, Dict(agency_name => agency_report_string_data_dict))
    end

    object.data_from_api_array = master_string_data_blob_array
end
#call this function if Fetch_data.method == "http"
data_from_http(object::Fetch_data, object_two::Initialise_agency_names_array, object_three::Initialise_report_names_array) = begin
    master_string_data_blob_array::Vector{Dict{String,Any}} = []

    lowercased_report_names_array = lowercase_report_names(object_three)
    list_of_agencies::Vector{String} = lowercase_agency_names(object_two)
    list_of_reports::Vector{String} = filter_report_names_array_to_include_everything_except_site_and_download(object_three, lowercased_report_names_array)
    # usagov_api_key::String = object.usagov_api_key
    # http_headers_for_api_request::Dict{String,String} = Dict("x-api-key" => usagov_api_key)
    base_url::String = ""
    for agency_name in list_of_agencies
        agency_report_string_data_dict::Dict{String,Any} = Dict()
        for report_name in list_of_reports
            base_url = format_url_for_http(object, agency_name, report_name)
            response = HTTP.request("GET", base_url)
            stringified_http_response = String(response.body)
            agency_report_string_data_dict[report_name] = stringified_http_response
        end
        push!(master_string_data_blob_array, Dict(agency_name => agency_report_string_data_dict))
    end

    object.data_from_http_array = master_string_data_blob_array
end


combine_data_of_api_and_http(object::Fetch_data, object_two::Initialise_agency_names_array) = begin
    data_blob = []
    data_blob_from_api = object.data_from_api_array
    data_blob_from_http = object.data_from_http_array
    list_of_agencies = lowercase_agency_names(object_two)
    number_of_agencies = length(data_blob_from_api)

    for index in 1:number_of_agencies
        agency_dict_data = Dict()
        for (report, data) in data_blob_from_api[index][list_of_agencies[index]]
            agency_dict_data[report] = data
        end
        for (report, data) in data_blob_from_http[index][list_of_agencies[index]]
            agency_dict_data[report] = data
        end
        push!(data_blob, agency_dict_data)
    end
    return data_blob #returns an array of dicts with agencies, with dict of reports with stringified data
end











#data manipulation and parsing
mutable struct Parse_data
    parsed_data_array
end
handle_csv_data_frame(object::Parse_data, csv_data) = begin
    final_data_dict_array = []
    csv_data_frame = csv_data |> DataFrame
    for row in eachrow(csv_data_frame)

        data_dict = Dict("page" => row[1], "page_title" => row[2], "active_visitors" => row[3]) #handle errors for empty dict
        push!(final_data_dict_array, data_dict)

    end
end

handle_json_data(object::Parse_data, json_data, report_name) = begin
    if report_name == "site"
        json_data_frame = json_data |> DataFrame
        final_data_dict_array = []
        for row in eachrow(json_data_frame)
            data_dict = Dict("domain" => row[1], "date" => row[3], "visits" => row[6])
            push!(final_data_dict_array, data_dict)
        end
        return final_data_dict_array
    elseif report_name == "download"
        json_data_frame = json_data |> DataFrame
        final_data_dict_array = []
        for row in eachrow(json_data_frame)
            data_dict = Dict("page_title" => row[1], "total_events" => row[2], "page" => row[4], "date" => row[5])
            push!(final_data_dict_array, data_dict)
        end
        return final_data_dict_array

    elseif report_name == "top-countries-realtime.json"
        json_data_frame = json_data["data"] |> DataFrame
        final_data_dict_array = []
        for row in eachrow(json_data_frame)
            data_dict = Dict("country" => row[1], "active_visitors" => row[2])
            push!(final_data_dict_array, data_dict)
        end
        return final_data_dict_array
    elseif report_name == "top-cities-realtime.json"
        json_data_frame = json_data["data"] |> DataFrame
        final_data_dict_array = []
        for row in eachrow(json_data_frame)
            data_dict = Dict("city" => row[1], "active_visitors" => row[2])
            push!(final_data_dict_array, data_dict)
        end
        return final_data_dict_array
    elseif report_name == "top-traffic-sources-30-days.json"
        json_data_frame = json_data["data"] |> DataFrame
        final_data_dict_array = []
        for row in eachrow(json_data_frame)
            data_dict = Dict("users" => row[3], "page_views" => row[7], "visits" => row[8])
            push!(final_data_dict_array, data_dict)
        end
        return final_data_dict_array
    end
end

parse_all_data(object::Parse_data, data_array) = begin
    #returns an array of dicts
    #dict->agencyname : dict("data")
    for agency in data_array
        parsed_agency_data_dict = Dict()
        for (report_name, data) in agency
            if report_name == "all-pages-realtime.csv"
                csv_parsed_data = CSV.File(IOBuffer(data))
                formatted_csv_data_array = handle_csv_data_frame(object, csv_parsed_data)
                parsed_agency_data_dict[agency] = formatted_csv_data_array

            else
                json_parsed_data = JSON.Parser.parse(data)
                formatted_json_data_array = handle_json_data(object, json_parsed_data, report_name)
                parsed_agency_data_dict[agency] = formatted_json_data_array

            end
        end
        push!(object.parsed_data_array, parsed_agency_data_dict)
    end
end
















struct Mongodb_struct
    mongodb_username
    mongodb_password
    mongodb_database_name
    mongodb_collection_name
end

connect_to_mongodb_atlas(object::Mongodb_struct) = begin
    mongodb_username = object.mongodb_username
    mongodb_password = object.mongodb_password
    mongodb_connection_uri = "mongodb+srv://$mongodb_username:$mongodb_password@cluster0.bnbnwjz.mongodb.net/?retryWrites=true&w=majority"
    mongodb_client = Mongoc.Client(mongodb_connection_uri)
    return mongodb_client
end

disconnect_mongodb_atlas(object::Mongodb_struct, mongo_client) = begin
    Mongoc.Disconnect!(mongo_client)
end

upload_data_to_mongodb_atlas(object::Mongodb_struct, mongo_client, data) = begin
    #data here is an array of dicts with agency key with array of dicts
    mongodb_collection = mongo_client[object.mongodb_database_name][object.mongodb_collection_name]
    println(length(data))
    for agency_data_dict in data
        for (agency_label, agency_data) in agency_data_dict
            existing_agency_document_check = Mongoc.find_one(mongodb_collection, Mongoc.BSON(Dict("id" => agency_label)))
            if isnothing(existing_agency_document_check)
                data_to_be_uploaded = Dict("id" => agency_label, agency_label => Mongoc.BSON(agency_data))
                Mongoc.insert_one(mongodb_collection, Mongoc.BSON(data_to_be_uploaded))
            end
        end
    end
end
empty_data_from_mongodb_collection(object::Mongodb_struct, client) = begin
    empty!(client[object.mongodb_database_name][object.mongodb_collection_name])
end

#for site report  ["domain","visits","date"]
#for download report ["page",page_title","total_events","Date"]
#for all-pages-realtime.csv report []
#for top-countries-realtime.json report [] , dict["data"] = > array
#for top-cities-realtime.json report []
#for top-traffic-sources-30-days.json report []
##############################################################################




#INSTANTIATING structures

current_project_environment_variables_object = Environment_variable_struct("usagov-site-analytics")
environment_variables_dict_array = get_environment_variables(current_project_environment_variables_object, ["MONGODB_USERNAME", "MONGODB_PASSWORD", "USA_GOV_API_KEY"])
mongodb_username_env = environment_variables_dict_array[1]["MONGODB_USERNAME"]
mongodb_password_env = environment_variables_dict_array[2]["MONGODB_PASSWORD"]
usa_gob_api_key_env = environment_variables_dict_array[3]["USA_GOV_API_KEY"]
agency_name_list = [
    "All",
    "Agency-international-development",
    "Agriculture",
    "Commerce",
    "Defense",
    "Education",
    "Energy",
    "Environmental-protection-agency",
    "Executive-office-president",
    "General-services-administration",
    "Health-human-services",
    "Homeland-security",
    "Housing-urban-development",
    "Interior",
    "Justice",
    "Labor",
    "National-aeronautics-space-administration",
    "National-archives-records-administration",
    "National-science-foundation",
    "Nuclear-regulatory-commission",
    "Office-personnel-management",
    "Postal-service",
    "Small-business-administration",
    "Social-security-administration",
    "State",
    "Transportation",
    "Treasury",
    "Veterans-affairs"
]
agency_names_object = Initialise_agency_names_array(agency_name_list)
lowercased_agency_names_array = lowercase_agency_names(agency_names_object)
capitalised_agency_names_array = capitalise_agency_names(agency_names_object)

report_name_list = [
    "site",
    "download",
    "all-pages-realtime.csv",
    "top-traffic-sources-30-days.json",
    "top-countries-realtime.json",
    "top-cities-realtime.json"
]
report_names_object = Initialise_report_names_array(report_name_list)
lowercased_report_names_array = lowercase_report_names(report_names_object)
report_names_array_including_site_and_download = filter_report_names_array_to_include_site_and_download(report_names_object, lowercased_report_names_array)
report_names_array_excluding_site_and_download = filter_report_names_array_to_include_everything_except_site_and_download(report_names_object, lowercased_report_names_array)





fetch_data_object = Fetch_data([], [], usa_gob_api_key_env)
#these functions dont return anything, they are setting the mutable structs values to returned data blob
data_from_api(fetch_data_object, agency_names_object, report_names_object)
data_from_http(fetch_data_object, agency_names_object, report_names_object)

data_from_http_and_api_combined_array = combine_data_of_api_and_http(fetch_data_object, agency_names_object)
# println(data_from_http_and_api_combined_array)




#parsing data object
parse_data_object = Parse_data([])
parse_all_data(parse_data_object, data_from_http_and_api_combined_array)
# println(parse_data_object.parsed_data_array)





#mongodb instance
current_project_mongodb_object = Mongodb_struct(mongodb_username_env, mongodb_password_env, "usa_gov_site_analytics", "agencies_report_data")

mongodb_client = connect_to_mongodb_atlas(current_project_mongodb_object)
empty_data_from_mongodb_collection(current_project_mongodb_object, mongodb_client)
upload_data_to_mongodb_atlas(current_project_mongodb_object, mongodb_client, parse_data_object.parsed_data_array)
disconnect_mongodb_atlas(current_project_mongodb_object, mongodb_client)













################################Functional code#############################################################
