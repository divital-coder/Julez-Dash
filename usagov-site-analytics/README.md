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







peopel on all sites right : all-pages-real-time-report
total users (past month) : 
total visits (pasth month) : site-report-data







-number of people on all sites of that agency 


-total users on all of the sites of that agency wihtin past month 

-total visits on all of the sites of that agency within past month 



-TRaffic breakdown 
:total number of visits today which are time stamped on a graph , (are on all of the sites and subdomains of that agency)

:location of visitors, highlighted within each state on the US map (on all sites of that agency) 
https://analytics.usa.gov/data/live/top-cities-realtime.json

:Top downloads (yesterday) (under the agency sites) [DOWNLOAD REPORT]
download for all
agency specific downloadd


for ALL option
reports : downloads, domain
queried with after=2023-11-13



for each agency , we needed site report 
returns=> array of objects 
{"domain":"usaid.gov","id":133011767,"date":"2023-11-13","report_name":"site","report_agency":"agency-international-development","visits":48099}
reports for each agency : site , download , traffic-source





STUFF DONE SO FAR :

DATA TO BE FETCHED FROM THE DATABASE 
DATA TO BE MANIPULATED
DATA TO BE PRESENTED




each agency : 
site data : fire
download data : 
all pages realtime data : 
top traffic sources 30 days data : 
top countries realtime data :
top cities realtime data : 




