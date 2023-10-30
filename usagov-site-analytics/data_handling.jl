using Pkg;
using HTTP;
Pkg.add("JSON");
Pkg.add("Mongoc");
using JSON;
using Mongoc;
list_of_agencies =[
    "All",
    "agency-international-development",
    "agriculture",
    "commerce",
    "defense",
    "education",
    "energy",
    "environmental-protection-agency",
    "executive-office-president",
    "general-services-administration",
    "health-human-services",
    "homeland-security",
    "housing-urban-development",
    "interior",
    "justice",
    "labor",
    "national-aeronautics-space-administration",
    "nationa-archives-records-administration",
    "national-science-foundation",
    "nuclear-regulatory-commission",
    "office-personnel-management",
    "postal-service",
    "small-business-administration",
    "social-security-administration",
    "state",
    "transportation",
    "treasury",
    "veterans-affairs"
];

list_of_report_types = [
    "download",
    "site",
    "traffic source",
    "domain",
    "second-level-domain",
    "language",
    "browser",
    "ie",
    "device"
];


agency_name = "treasury";
report_type = "site";

function fetch_report_types()
    return list_of_report_types;    
end

function fetch_agencies()
    return list_of_agencies;

end

# notes for mongodb connection 
# ensure ur tsl errors by setting ssl_cert_file to your cert.pem
# also make sure to removev the braces in ur connection string 

function database_connectivity()
    connection_uri = "mongodb+srv://hurtbadly:tricycle123@cluster0.bnbnwjz.mongodb.net/?retryWrites=true&w=majority";
    client_connection = Mongoc.Client(connection_uri); 
    println(Mongoc.ping(client_connection));
    document = Dict("dummykeyone"=>"dummyvalueone","dummykeytwo"=>"dummyvaluetwo","dummykeythree"=>"dummyvvaluethree");


end



function  fetch_data()
    api_url = "https://api.gsa.gov/analytics/dap/v1.1/agencies/$agency_name/reports/$report_type/data"
    api_key = "2ewzKQCV735zgUfXyH0OsNUI1q72isLO6BjNd7xQ"
    http_headers = Dict("x-api-key" => api_key);
    response = HTTP.request("GET",api_url,http_headers);
    data_blob = JSON.Parser.parse(String(response.body))
    println(JSON.json(data_blob));
end

database_connectivity();



# fetch_data();

