using Pkg;
Pkg.add(["DotEnv","HTTP","JSON","Mongoc","CSV","DataFrames"]);

using DotEnv, HTTP, JSON , CSV, Mongoc, DataFrames;
# using Dates;
# page page_title active_visitors

#configuring environment variables
DotEnv.config();


#global vars
UPLOAD_DATA_TO_MONGODB = true;




# function handle_queries(url,time)
#     current_date = Dates.today();
#     past_week_date = current_date - Dates.Day(7);
#     past_month_date = current_date - Dates.Month(1);

#     if time == "month"
#         url = "$url?after=$past_week_date";
#         return url;
#     end

#     url = "$url?after=$past_week_date";
#     return url; 
# end




function handle_csv_data(data_blob)
json_data_array = [];
for row in eachrow(data_blob)
    row_dict = Dict("page"=>row[1],"page_title"=>row[2],"active_visitors"=>row[3]);
    push!(json_data_array,row_dict);
end
return json_data_array;

end

function fetch_report_names()
report_name_list = [
"site",
"download",
"all-pages-realtime.csv",
"top-traffic-sources-30-days.json",
"top-countries-realtime.json",
"top-cities-realtime.json"
]
return report_name_list;
end
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




function upload_data_mongodb(data_blob_array,agency_name)
#handling data 
site_report_data = data_blob_array[1];
download_report_data = data_blob_array[2];
allpagesrealtime_report_data = data_blob_array[3];
toptrafficsources30days_report_data = data_blob_array[4];
topcountriesrealtime_report_data = data_blob_array[5];
topcitiesrealtime_report_data =  data_blob_array[6];




# handling csv data 
    

#establish connection wtih the mongodb atlas
mongodb_atlas_access_code = ENV["MONGODB_ACCESS_CODE"];
mongodb_username = ENV["MONGODB_USERNAME"];
mongodb_password = ENV["MONGODB_PASSWORD"];
agency_data_to_be_uploaded = Dict("id"=>agency_name, "site-report-data"=>Mongoc.BSON(site_report_data), "download-report-data"=>Mongoc.BSON(download_report_data),"all-pages-realtime-report-data"=>Mongoc.BSON(allpagesrealtime_report_data),"top-traffic-sources-30-days-report-data"=>Mongoc.BSON(toptrafficsources30days_report_data),"top-countries-realtime-report-data"=>Mongoc.BSON(topcountriesrealtime_report_data),"top-cities-realtime-report-data"=>Mongoc.BSON(topcitiesrealtime_report_data));


mongodb_connection_uri = "mongodb+srv://$mongodb_username:$mongodb_password@cluster0.bnbnwjz.mongodb.net/?retryWrites=true&w=majority";
client_connection  = Mongoc.Client(mongodb_connection_uri);
mongodb_target_data_collection = client_connection["usa_gov_site_analytics"]["agencies_report_data"];

exising_document_check = Mongoc.find_one(mongodb_target_data_collection,Mongoc.BSON(Dict("id"=>agency_name)));

if isnothing(exising_document_check)
Mongoc.insert_one(mongodb_target_data_collection,Mongoc.BSON(agency_data_to_be_uploaded));
end
# print(Mongoc.BSON(agency_site_json_data))
# print(Mongoc.ping(client_connection))
end


function fetch_agency_data_from_api()
    agencies_list = fetch_agency_names("agency_name_list");
    reports_list = fetch_report_names();
    chosen_agency_name = "";
    chosen_report_name = "";
    usa_gov_api_key = ENV["USA_GOV_API_KEY"];
    
    http_headers_for_api_fetch = Dict("x-api-key"=>"$usa_gov_api_key");
    # println(length(agencies_list));
    lowercase_agencies_list_excluding_all = [];
    for agency in agencies_list
    push!(lowercase_agencies_list_excluding_all,lowercase(agency));
    end
    lowercase_agencies_list_excluding_all = lowercase_agencies_list_excluding_all[2:end];    
  
  # println(agencies_list[2])
    for num in 1:length(agencies_list)
        data_blob_array = [];
        data_is_csv = false; #checks for whether the requested data is csv or not 
        make_http_requests = false;


        for report in reports_list
            chosen_report_name = report;
            lowercase_agency_name = lowercase(agencies_list[num]);
            chosen_agency_name = lowercase_agency_name;
            usa_gov_api_url = "";
            usa_gov_http_url = "";

  
           
            
            


            # different things for "all" and individual agencies
            if (chosen_agency_name == "all" && (chosen_report_name in ["site","download"]))
                usa_gov_api_url = "https://api.gsa.gov/analytics/dap/v1.1/reports/$chosen_report_name/data";
                make_http_requests = false;


            elseif(chosen_agency_name == "all" && (chosen_report_name in ["all-pages-realtime.csv","top-traffic-sources-30-days.json","top-countries-realtime.json","top-cities-realtime.json"]))
                usa_gov_http_url = "https://analytics.usa.gov/data/live/$chosen_report_name";
                make_http_requests = true;

                if chosen_report_name == "all-pages-realtime.csv"
                    data_is_csv = true;
                else
                    data_is_csv = false;
                end
                
                
            elseif(chosen_agency_name  in lowercase_agencies_list_excluding_all && (chosen_report_name in ["site","download"]))
                usa_gov_api_url = "https://api.gsa.gov/analytics/dap/v1.1/agencies/$chosen_agency_name/reports/$chosen_report_name/data";
                make_http_requests = false;
            elseif(chosen_agency_name in lowercase_agencies_list_excluding_all && (chosen_report_name in ["all-pages-realtime.csv","top-traffic-sources-30-days.json","top-countries-realtime.json","top-cities-realtime.json"]))
                usa_gov_http_url = "https://analytics.usa.gov/data/$chosen_agency_name/$chosen_report_name";
                make_http_requests = true;
                if chosen_report_name == "all-pages-realtime.csv"
                    data_is_csv = true;
                else
                    data_is_csv = false;
                end

                
            end
            

            if(data_is_csv && make_http_requests) 

                requested_content = HTTP.request("GET",usa_gov_http_url);
                returned_data_blob = CSV.File(requested_content.body) |> DataFrame;
                returned_data_blob = handle_csv_data(returned_data_blob);
                push!(data_blob_array,returned_data_blob);

            elseif (!data_is_csv && make_http_requests)
                

                    requested_content = HTTP.request("GET",usa_gov_http_url);
                    returned_data_blob = JSON.Parser.parse(String(requested_content.body));
                    push!(data_blob_array,returned_data_blob);

            elseif (!data_is_csv && !make_http_requests)


                requested_content = HTTP.request("GET",usa_gov_api_url, http_headers_for_api_fetch);
                returned_data_blob = JSON.Parser.parse(String(requested_content.body)); 
                push!(data_blob_array, returned_data_blob);
            end
            
        end
        #no need to create a file since data base have been connected
        #newfile = open("./agencies_site_report_data/$chosen_agency_name-site-report.json","w");
        # write(newfile,JSON.json(returned_data_blob));
        # close(newfile);
        upload_data_mongodb(data_blob_array,chosen_agency_name);
    end
end









if UPLOAD_DATA_TO_MONGODB
fetch_agency_data_from_api();
UPLOAD_DATA_TO_MONGODB = false;
end
# upload_data_mongodb()




#for all
# https://analytics.usa.gov/data/live/all-pages-realtime.csv
# https://analytics.usa.gov/data/live/top-traffic-sources-30-days.json
# https://analytics.usa.gov/data/live/top-countries-realtime.json
# https://analytics.usa.gov/data/live/top-cities-realtime.json



