using Pkg;
Pkg.add("Dash"); #this enables us to launch our web app
Pkg.add("Plotly"); #this enables us to create plots and graphs

using Dash;
using Plotly;
include("./data_stuff.jl");
#for dropdowns u need an options attribute ,and that attribute needs  an array of dictionary with key value pairs of label and value

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





        html_main(
        # left pane things  
        html_div(className = "left_pane"),
                
                
                
                
        # right pane things 
        html_div(
                children=[


                ],    
                className="right_pane")
        ),

        



        html_footer(children=[
            html_p("made with love by "),
            html_a("@hurtbadly2", href = "https://x.com/hurtbadly2", className = "footer_redirect_link")
        ], className = "site_footer")
    ]);












Application = dash(external_stylesheets=["./assets/styles.css"]);
Application.title = "usa.gov | Site Analytics";
Application.layout = frontend_layout;


run_server(Application,"0.0.0.0",debug=true);

