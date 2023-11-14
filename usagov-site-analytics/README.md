tech : julia , mongodb, plotly (graphs)
packages within the julia environment : 
HTTP (Making requests)
JSON (PARSING JSON DATA)
DASH (WEB FRAMEWORK FOR BUILDING OUR APP)
PLOTLY (PLOTTING GRAPHS)
DOTENV (ACCESSING ENVIRONMENT VARIABLES)
MONGOC (FOR INTERACTING WITH YOUR MONGODB ATLAS INSTANCES)

ENVIRONMENT VARIABLES (.ENV) WITHIN ROOT OF YOUR PROJECT


USA_GOV_API_KEY=yourkey
MONGODB_ACCESS_CODE= yourcode 
MONGODB_USERNAME = yourusername
MONGODB_PASSWORD= yourpassword


usagov_api_url = "https://api.gsa.gov/analytics/dap/dv1.1"


manipulating url for relevant data : 

    /reports/<report name>/data
    /agencies/<agency name>/reports/<report name>/data
    /domain/<domain>/reports/<report name>/data

request to the api
x-api-key = ENV["usa_gov_api_key"]



reports that can be fetched from the api 

  ce  download (example) 
    traffic-sour (example)
    domain (example)
    site (example)
    second-level-domain (example)
    browser (example)
    os (example)





list of agencies/departments that can be queried
    all
    agency-international-development 
    agriculture 
    commerce 
    defense 
    education 
    energy 
    environmental-protection-agency 
    executive-office-president 
    general-services-administration 
    health-human-services 
    homeland-security 
    housing-urban-development 
    interior 
    justice 
    labor 
    national-aeronautics-space-administration 
    national-archives-records-administration 
    national-science-foundation 
    nuclear-regulatory-commission 
    office-personnel-management 
    postal-service 
    small-business-administration 
    social-security-administration 
    state 
    transportation 
    treasury 
    veterans-affairs 







data on the main page for each agency
-POPULAR SECTION
:Top domains (past week) [DOMAIN-REPORT] [SITE] [SECOND-LEVEL-DOMAIN]
:Top domains (past month) [DOMAIN-REPORT] [SITE] [SECOND-LEVEL-DOMAIN]
:Top pages (now) [DOMAIN-REPORT] [SITE] [SECOND-LEVEL-DOMAIN]


-number of people on all sites of that agency [TRAFFIC-SOURCE REPORT]
-total users on all of the sites of that agency wihtin past month [TRAFFIC-SOURCE REPORT]
-total visits on all of the sites of that agency within past month [TRAFFIC-SOURCE REPORT]


-TRaffic breakdown 
:total number of visits today which are time stamped on a graph , (are on all of the sites and subdomains of that agency) [TRAFFIC-SOURCE REPORT]
:location of visitors, highlighted within each state on the US map (on all sites of that agency) [TRAFFIC-SOURCE REPORT]
:Top downloads (yesterday) (under the agency sites) [DOWNLOAD REPORT]




for each agency , we needed site report 
returns=> array of objects 
{"domain":"usaid.gov","id":133011767,"date":"2023-11-13","report_name":"site","report_agency":"agency-international-development","visits":48099}



STUFF DONE SO FAR :

DATA FETCHED FROM THE API
DATA TO BE PUSED INTO THE DATABASED
DATA TO BE FETCHED FROM THE DATABASE 
DATA TO BE MANIPULATED
DATA TO BE PRESENTED
