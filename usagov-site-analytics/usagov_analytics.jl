
# things to setup , setup a basic design and html markup of the page 
# fetch data from the usa gov api using the apporproate queries for report type and agency type 
# parse that data into json readable format 
# get that data, make a merkup of the page and have it ready for hosting on the mongodb atlas for hosting

using Pkg;
Pkg.add("Dash");


using Dash;

include("./data_handling.jl");


# data stuff 

list_of_agencies = fetch_agencies();
list_of_report_types = fetch_report_types();

agency_dropdown_options = [];
println(list_of_agencies);
for agency in list_of_agencies
    dropdown_dict = Dict("label"=>agency, "value"=>agency);
    push!(agency_dropdown_options,dropdown_dict);
end

#data stuff 


Application = dash(external_stylesheets = ["./assets/styles.css"]);
Application.title = "USA.GOV Site Analytics";
application_layout = html_div(children = [
    html_header(
        children = [
        html_img(src="./assets/usagov_logo.png" , alt = "USA.GOV logo" , className="usagov_logo"),
        html_h1("USA GOVERNMENT WEBSITE ANALYTICS", className="site_heading"),
        dcc_dropdown(options = agency_dropdown_options ,value = agency_dropdown_options[1]["value"], className="agency_dropdown"),
        html_div(children = [
            html_a("USA.Gov", href = "https://www.usa.gov")
        ], className = "site_redirect_link")
    ],
    className = "content-header"
)


]);

Application.layout = application_layout;
run_server(Application, "0.0.0.0", debug = true);