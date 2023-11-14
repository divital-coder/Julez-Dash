using Pkg;
Pkg.add("DotEnv");
Pkg.add("HTTP");
Pkg.add("JSON");
Pkg.add("Mongoc");
using DotEnv;
using HTTP;
using JSON;
using Mongoc;


#configuring environment variables
DotEnv.config();


#global vars
UPLOAD_DATA_TO_MONGODB = true;


#agency names 
function fetch_agency_names(necessity)
    agency_dropdown_options_array = [];
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
        "Housing-urban-development" ,
        "Interior", 
        "Justice", 
        "Labor" ,
        "National-aeronautics-space-administration", 
        "National-archives-records-administration" ,
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
    ];

    if necessity == "agency_dropdown_options"
    for agency in agency_name_list
        agency_splitted_array = split(agency,"-");
        agency = join(agency_splitted_array," ");
        agency_dictionary = Dict("label"=>agency, "value"=>agency);
        push!(agency_dropdown_options_array,agency_dictionary); # beware of push functions while coding 
    end

    return agency_dropdown_options_array;
else
return agency_name_list;
end

end




function upload_data_mongodb(agency_site_json_data,agency_name)
#establish connection wtih the mongodb atlas
mongodb_atlas_access_code = ENV["MONGODB_ACCESS_CODE"];
mongodb_username = ENV["MONGODB_USERNAME"];
mongodb_password = ENV["MONGODB_PASSWORD"];
agency_data_to_be_uploaded = Dict("id"=>agency_name, "data"=>Mongoc.BSON(agency_site_json_data));


mongodb_connection_uri = "mongodb+srv://$mongodb_username:$mongodb_password@cluster0.bnbnwjz.mongodb.net/?retryWrites=true&w=majority";
client_connection  = Mongoc.Client(mongodb_connection_uri);
mongodb_target_data_collection = client_connection["usa_gov_site_analytics"]["agencies_site_report_data"];

exising_document_check = Mongoc.find_one(mongodb_target_data_collection,Mongoc.BSON(Dict("id"=>agency_name)));

if isnothing(exising_document_check)
Mongoc.insert_one(mongodb_target_data_collection,Mongoc.BSON(agency_data_to_be_uploaded));
end
# print(Mongoc.BSON(agency_site_json_data))
# print(Mongoc.ping(client_connection))
end

function fetch_agency_data_from_api()
    agencies_list = fetch_agency_names("agency_name_list");
    chosen_agency_name = "";
    chosen_report_name = "site";
    usa_gov_api_key = ENV["USA_GOV_API_KEY"];
    
    http_headers = Dict("x-api-key"=>"$usa_gov_api_key");
    
    # println(length(agencies_list));
    # println(agencies_list[2])
    for num in 2:length(agencies_list)
        lowercase_agency_name = lowercase(agencies_list[num])
        chosen_agency_name = lowercase_agency_name;
        usa_gov_api_url = "https://api.gsa.gov/analytics/dap/v1.1/agencies/$chosen_agency_name/reports/$chosen_report_name/data";
        requested_content  = HTTP.request("GET", usa_gov_api_url, http_headers);
        returned_data_blob = JSON.Parser.parse(String(requested_content.body));

        #no need to create a file since data base have been connected
        #newfile = open("./agencies_site_report_data/$chosen_agency_name-site-report.json","w");
        # write(newfile,JSON.json(returned_data_blob));
        # close(newfile);
        upload_data_mongodb(returned_data_blob,chosen_agency_name);
             
    end
end     








if UPLOAD_DATA_TO_MONGODB
fetch_agency_data_from_api();
UPLOAD_DATA_TO_MONGODB = false;
end
# upload_data_mongodb()