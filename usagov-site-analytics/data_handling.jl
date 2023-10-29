using Pkg;
using HTTP;
Pkg.add("JSON");
using JSON;

list_of_agencies =[
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




function  fetch_data()
    api_url = "https://api.gsa.gov/analytics/dap/v1.1/agencies/$agency_name/reports/$report_type/data"
    api_key = "2ewzKQCV735zgUfXyH0OsNUI1q72isLO6BjNd7xQ"
    http_headers = Dict("x-api-key" => api_key);
    response = HTTP.request("GET",api_url,http_headers);
    data_blob = JSON.Parser.parse(String(response.body))
    println(JSON.json(data_blob));
end






# fetch_data();

