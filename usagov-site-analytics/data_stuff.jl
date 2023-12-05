# all about fetching the data from the api and feeding it within the mongodb instance


using Pkg;
Pkg.add(["DotEnv", "HTTP", "JSON", "Mongoc", "CSV", "DataFrames", "BSON"]);

using DotEnv, HTTP, JSON, CSV, Mongoc, DataFrames, BSON;
# using Dates;
# page page_title active_visitors

#configuring environment variables
DotEnv.config();
# ODBC.adddriver("ODBC Driver 18 for SQL Server");


#global vars
UPLOAD_DATA_TO_MONGODB = false;




function format_url_for_data_request(agency_name, report_name)
    if agency_name == "all" && report_name in ["site", "download"]
        return "https://api.gsa.gov/analytics/dap/v1.1/reports/$report_name/data"
    elseif agency_name != "all" && report_name in ["site", "download"]
        return "https://api.gsa.gov/analytics/dap/v1.1/agencies/$agency_name/reports/$report_name/data"


    elseif agency_name == "all" && !(report_name in ["site", "download"])
        return "https://analytics.usa.gov/data/live/$report_name"
    elseif agency_name != "all" && !(report_name in ["site", "download"])
        return "https://analytics.usa.gov/data/$agency_name/$report_name"
    end
end




#############################################################################

#OBJECT ORIENTED PROGRAMMING BEGINS

#               environment variables structures
mutable struct Environment_variable_struct
    environment_variable_dict_array
end

get_environment_variables(object::Environment_variable_struct, env_variable_array) = begin
    object.environment_variable_dict_array = []
    for env_var_name in env_variable_array
        push!(object.environment_variable_dict_array, Dict(env_var_name => ENV[env_var_name]))
    end
end






#       agency names structure
struct Initialise_agency_names_array
    agency_names_array
end

lowercase_agency_names(object::Initialise_agency_names_array) = begin
    agency_names_array = object.agency_names_array
    lowercased_agency_names_array = []
    for agency_name in agency_names_array
        push!(lowercased_agency_names_array, lowercase(agency_name))
    end
    return lowercased_agency_names_array
end

capitalise_agency_names(object::Initialise_agency_names_array) = begin
    agency_names_array = object.agency_names_array
    capitalised_agency_names_array = []
    for agency_name in agency_names_array
        push!(capitalised_agency_names_array, uppercasefirst(agency_name))
    end
    return capitalised_agency_names_array
end







#       report names structure
struct Initialise_report_names_array
    report_names_array
end

lowercase_report_names(object::Initialise_report_names_array) = begin
    report_names_array = object.report_names_array
    lowercased_report_names = []
    for report_name in report_names_array
        push!(lowercased_report_names, lowercase(report_name))
    end
    return lowercased_report_names
end





mutable struct Requested_dataframe_dict_array
    string_data_dict_array
    dataframe_dict_array
end

fetch_string_data(object::Requested_dataframe_dict_array, agency_names_array, report_names_array, usa_gov_api_key) = begin
    string_data_dict_array = []
    headers = Dict("x-api-key" => usa_gov_api_key)
    for agency in agency_names_array
        agency_dict = Dict("id" => agency)
        for report in report_names_array
            formatted_url = format_url_for_data_request(agency, report)
            response = HTTP.request("GET", formatted_url, headers)
            stringified_data_body = String(response.body)
            agency_dict[report] = stringified_data_body
        end
        push!(string_data_dict_array, agency_dict)
    end
    object.string_data_dict_array = string_data_dict_array
    return string_data_dict_array
end


parse_json_data(data) = begin
    parsed_json_data_frame = JSON.Parser.parse(data) |> DataFrame
    return parsed_json_data_frame
end

parse_csv_data(data) = begin
    parsed_csv_data_frame = CSV.File(IOBuffer(data)) |> DataFrame
    return parsed_csv_data_frame
end

set_dataframe_dict_array(object::Requested_dataframe_dict_array, string_data_dict_array) = begin
    for agency_dict in string_data_dict_array
        dataframe_dict = Dict()
        for (key, value) in agency_dict
            if key == "id"
                dataframe_dict[key] = value
            else
                if key == "all-pages-realtime.csv"
                    dataframe_dict[key] = first(parse_csv_data(value), 50)
                elseif !(key in ["site", "download"])
                    dataframe_dict[key] = parse_json_data(value)
                    data = dataframe_dict[key]
                    dataframe_dict[key] = first(data[!, :data] |> DataFrame, 50)

                elseif (key in ["site", "download"])
                    dataframe_dict[key] = first(parse_json_data(value), 50)
                end
            end
        end
        push!(object.dataframe_dict_array, dataframe_dict)
    end
    return object.dataframe_dict_array
end





struct Mongodb_stuff
    mongodb_username
    mongodb_password
    mongodb_connection_uri
    mongodb_database_name
    mongodb_collection_name
end



initiate_connection(object::Mongodb_stuff) = begin
    client = Mongoc.Client(object.mongodb_connection_uri)
    return client
end



empty_mongodb_collection(object::Mongodb_stuff, client) = begin
    empty!(client[object.mongodb_database_name][object.mongodb_collection_name])
end
upload_data_to_mongodb(object::Mongodb_stuff, client, data) = begin
    mongodb_collection = client[object.mongodb_database_name][object.mongodb_collection_name]
    for agency_dict in data
        # agency_dict = Mongoc.BSON(agency_dict)
        existing_document_check = Mongoc.find_one(mongodb_collection, Mongoc.BSON(Dict("id" => agency_dict["id"])))
        if isnothing(existing_document_check)
            Mongoc.insert_one(mongodb_collection, Mongoc.BSON(agency_dict))
        end
    end
end



retrieve_data_from_mongodb(object::Mongodb_stuff, client) = begin
    agency_dict_array = []
    for document in client[object.mongodb_database_name][object.mongodb_collection_name]
        agency_dict = Dict()
        for (key, value) in document
            if key != "_id"
                agency_dict[key] = value
            end
        end
        push!(agency_dict_array, agency_dict)
    end
    return agency_dict_array
end


disband_connection(object::Mongodb_stuff, client) = begin
    Mongoc.destroy!(client)
end

#for site report  ["domain","visits","date"]
#for download report ["page",page_title","total_events","Date"]
#for all-pages-realtime.csv report []
#for top-countries-realtime.json report [] , dict["data"] = > array
#for top-cities-realtime.json report []
#for top-traffic-sources-30-days.json report []
##############################################################################




#INSTANTIATING structures

current_project_environment_variables_object = Environment_variable_struct([])
get_environment_variables(current_project_environment_variables_object, ["MONGODB_USERNAME", "MONGODB_PASSWORD", "USA_GOV_API_KEY", "MONGODB_CONNECTION_URI", "MONGODB_DATABASE_NAME", "MONGODB_COLLECTION_NAME"])
mongodb_username_env = current_project_environment_variables_object.environment_variable_dict_array[1]["MONGODB_USERNAME"]
mongodb_password_env = current_project_environment_variables_object.environment_variable_dict_array[2]["MONGODB_PASSWORD"]
usa_gov_api_key_env = current_project_environment_variables_object.environment_variable_dict_array[3]["USA_GOV_API_KEY"]
mongodb_connection_uri = current_project_environment_variables_object.environment_variable_dict_array[4]["MONGODB_CONNECTION_URI"]
mongodb_database_name = current_project_environment_variables_object.environment_variable_dict_array[5]["MONGODB_DATABASE_NAME"]
mongodb_collection_name = current_project_environment_variables_object.environment_variable_dict_array[6]["MONGODB_COLLECTION_NAME"]
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

request_dataframe_dict_array_object = Requested_dataframe_dict_array([], [])
string_data_dict_array = fetch_string_data(request_dataframe_dict_array_object, lowercased_agency_names_array, lowercased_report_names_array, usa_gov_api_key_env)




#uploading to database stuff
mongodb_object = Mongodb_stuff(mongodb_username_env, mongodb_password_env, mongodb_connection_uri, mongodb_database_name, mongodb_collection_name)
mongo_client = initiate_connection(mongodb_object)
if UPLOAD_DATA_TO_MONGODB

empty_mongodb_collection(mongodb_object, mongo_client)
upload_data_to_mongodb(mongodb_object, mongo_client, string_data_dict_array)
disband_connection(mongodb_object, mongo_client)
end




################################Functional code#############################################################



