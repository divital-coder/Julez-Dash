using Pkg;
Pkg.add("Dash"); #this enables us to launch our web app
Pkg.add("Plotly"); #this enables us to create plots and graphs

include("./data_stuff.jl");
include("./data_logic.jl");
using Dash;
using PlotlyJS;
#for dropdowns u need an options attribute ,and that attribute needs  an array of dictionary with key value pairs of label and value
# this functions returns a value which the user have chosen from the dropdown menu
function return_agency_from_the_dropdown(agency_name)
lowercased_agency_name = lowercase(agency_name);
return lowercased_agency_name;
end


# GLOBAL VARAIBLES 
TOP_DOMAIN_DATA_DICT = nothing;




header_agency_dropdown_options = fetch_agency_names("agency_dropdown_options");


#here we are simply storting and creating the html and css layout for our app
frontend_layout =  html_div(children=[
    html_header(children=[
        html_img(src="./assets/usagov_logo.png",alt="USA GOV LOGO", className = "usagov_logo"),
        html_h1("USA GOVERNMENT WEBSITE ANALYTICS", className = "site_heading"),
        dcc_dropdown(options=header_agency_dropdown_options, value=header_agency_dropdown_options[1]["value"], style=Dict("border"=>"none","display"=>"flex","align-items"=>"center","justify-content"=>"center","text-align"=>"center","border-radius"=>"40px","cursor"=>"pointer","color"=>"black","font-family"=>"sans-serif"), id="agency_dropdown"),
        html_div(children=[
        html_a("usa.gov", href="https://usa.gov", className = "site_redirect_link")],className="site_redirect_link_container"),
        ], className = "content_header"),
# main section of the page 
        html_div(
            children = [
        # left pane things  
        html_div(children= [
            html_h2("Most Popular"),
            dcc_tabs(children = [
                Dict("label"=>"Top Domains\n(Past Week)","value"=>"weekly_domains"),
                Dict("label"=>"Top Domains\n(Past Month)","value"=>"monthly_domains"),
                Dict("label"=>"Top Pages\n(Now)", "value"=>"pages_now")
            ])] ,className = "left_pane"),              
        # right pane things 
        html_div(
                children=[
                html_h1("apple")
                ],    
                className="right_pane")]),

# footer section of the page 
        html_footer(children=[
            html_p("made with love by "),
            html_a("@hurtbadly2", href = "https://x.com/hurtbadly2", className = "footer_redirect_link")
        ], className = "site_footer")
    ]);









Application = dash(external_stylesheets=["./assets/styles.css"]);
Application.title = "usa.gov | Site Analytics";
Application.layout = frontend_layout;


 

# callbacks related to our application
callback!(Application,Output("showthis","children"),Input("agency_dropdown","value"))do selected_agency_option 
    lowercased_agency_name = return_agency_from_the_dropdown(selected_agency_option);
    # need to call the function that fetches data for the relevant agency 
    TOP_DOMAIN_DATA_DICT = fetch_site_report_data_from_mongodb(lowercased_agency_name); #this returns a dictionary with keys "monthly_domain_data", "weekly_domain_data", "now_domain_data" which are arrays of dictionaryies with key "domain", "visits"
    
    end
    
    
    

run_server(Application,"0.0.0.0",debug=true);




