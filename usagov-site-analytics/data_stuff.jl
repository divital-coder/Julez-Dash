# all about fetching the data from the api and feeding it within the mongodb instance


using Pkg;
Pkg.add(["DotEnv", "HTTP", "JSON", "Mongoc", "CSV", "DataFrames","BSON","ODBC"]);

using DotEnv, HTTP, JSON, CSV, Mongoc, DataFrames,BSON,ODBC;
# using Dates;
# page page_title active_visitors

#configuring environment variables
DotEnv.config();


#global vars
UPLOAD_DATA_TO_MONGODB = true;




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
                    dataframe_dict[key] = first(parse_csv_data(value), 5)
                elseif !(key in ["site", "download"])
                    dataframe_dict[key] = parse_json_data(value)
                    data = dataframe_dict[key]
                    dataframe_dict[key] = first(data[!, :data] |> DataFrame, 5)

                elseif (key in ["site", "download"])
                    dataframe_dict[key] = first(parse_json_data(value), 5)
                end
            end
        end
        push!(object.dataframe_dict_array, dataframe_dict)
    end
end






struct Microsoft_sql_database_struct
    ms_sql_database_name
    ms_sql_server_name
    ms_sql_admin_username
    ms_sql_admin_password
    ms_sql_connection_string
end
connect_to_ms_sql_database(object::Microsoft_sql_database_struct) = begin
    connected_client = ODBC.Connection(object.ms_sql_connection_string)
    return connected_client
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
get_environment_variables(current_project_environment_variables_object, ["MS_SQL_USERNAME", "MS_SQL_PASSWORD", "USA_GOV_API_KEY"])
ms_sql_username_env = current_project_environment_variables_object.environment_variable_dict_array[1]["MS_SQL_USERNAME"]
ms_sql_password_env = current_project_environment_variables_object.environment_variable_dict_array[2]["MS_SQL_PASSWORD"]
usa_gov_api_key_env = current_project_environment_variables_object.environment_variable_dict_array[3]["USA_GOV_API_KEY"]
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

request_dataframe_dict_array_object = Requested_dataframe_dict_array([])
string_data_dict_array = fetch_string_data(request_dataframe_dict_array_object, lowercased_agency_names_array, lowercased_report_names_array, usa_gov_api_key_env)
set_dataframe_dict_array(request_dataframe_dict_array_object, string_data_dict_array)










#uploading to database stuff
ms_database_name = "usa_gov_site_analytics"
ms_server_name = "usa-gov-site-analytics-database-server.database.windows.net"
ms_sql_connection_string = "Driver={ODBC Driver 18 for SQL Server};Server=tcp:usa-gov-site-analytics-database-server.database.windows.net,1433;Database=usa_gov_site_analytics;Uid=$ms_sql_username_env;Pwd=$ms_sql_password_env;Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
ms_sql_database_object = Microsoft_sql_database_struct(ms_database_name, ms_server_name, ms_sql_username_env, ms_sql_password_env, ms_sql_connection_string)
connected_client = connect_to_ms_sql_database(ms_sql_database_object)









################################Functional code#############################################################
