# operating over onto the site data 
using Pkg;
Pkg.add(["DotEnv","Mongoc","DataFrames","JSON"]);
using DotEnv, Mongoc, Dates, JSON;

# configuring dot env for env vars
DotEnv.config();

mongodb_access_code = ENV["MONGODB_ACCESS_CODE"];
mongodb_username = ENV["MONGODB_USERNAME"];
mongodb_password  = ENV["MONGODB_PASSWORD"];

# separate out the values for weekly and monthly 
function top_domain_data(document_data,agency)
    top_domain_data_dict = Dict();
    # we need visits and domains according to dates 

    #monthly 
    get_month_data = false;
    past_month_date = today() - Month(1);
    priority_data_dict_array_monthly = [];
# weekly 
    get_week_data = true;
    past_week_date = today() - Day(7);
    priority_data_dict_array_weekly = [];

# top pages now (all-pages-realtime-report-data)
    priority_data_dict_array_now = [];    



    document_data_site_report = document_data["site-report-data"];
    if document_data["id"] == agency
        document_data_site_report = document_data["site-report-data"];
    end
    number_of_objects = length(keys(document_data_site_report));
                    # println(document_data["site-report-data"]);                
    for num in 0 : number_of_objects-1
    entry_domain = document_data_site_report["$num"]["domain"];
    entry_date = document_data_site_report["$num"]["date"];
    entry_domain_visit_count = document_data_site_report["$num"]["visits"];



    # fetching monthly data         
    if get_month_data
        if Dates.format(Date(entry_date),"yyyy-mm-dd") < Dates.format(past_month_date, "yyyy-mm-dd")
            get_month_data = false;
        else
            push!(priority_data_dict_array_monthly,Dict("domain"=>entry_domain,"visits"=>entry_domain_visit_count));
        end
    end


    # fetching weekly data 
    if get_week_data
        if Dates.format(Date(entry_date),"yyyy-mm-dd") < Dates.format(past_week_date, "yyyy-mm-dd")
            get_week_data = false;
        else
            push!(priority_data_dict_array_weekly , Dict("domain"=>entry_domain, "visits"=>entry_domain_visit_count));
        end
    end
            # if(Date(object["dates"],"yyyy-mm-dd") < Date(String(past_week_date),"yyyy-mm-dd"))
    end         #     println(object);
            # end


    # managing and fetching data from the document
    number_of_object_in_realtime_data_key = length(document_data)



    top_domain_data_dict["monthly_domain_data"] = priority_data_dict_array_monthly;
    top_domain_data_dict["weekly_domain_data"] = priority_data_dict_array_weekly;
    top_domain_data_dict["now_domain_data"] = priority_data_dict_array_now;
    return top_domain_data_dict;
end



function fetch_site_report_data_from_mongodb(which_agency_data)
    mongodb_connection_uri = "mongodb+srv://$mongodb_username:$mongodb_password@cluster0.bnbnwjz.mongodb.net/?retryWrites=true&w=majority";
    client_connection  = Mongoc.Client(mongodb_connection_uri);
    mongodb_target_data_collection = client_connection["usa_gov_site_analytics"]["agencies_report_data"];
    agency_top_domain_data = nothing;
    # weekly 
    # acessing document from the collection individually 
    for document in mongodb_target_data_collection
        if document["id"] == which_agency_data
        agency_top_domain_data = top_domain_data(document,document["id"]); #concerned with domain, dates , visits
        break
        end
    end
    
    return agency_top_domain_data;  #here we are going to be getting 
end




print(fetch_site_report_data_from_mongodb("education"));