using Pkg;
Pkg.add("Dash"); #this enables us to launch our web app
Pkg.add("PlotlyJS"); #this enables us to create plots and graphs
Pkg.update();

include("./data_stuff.jl");
include("./data_logic.jl");
include("./front_data_manipulation.jl");
using Dash;
using PlotlyJS;

#for dropdowns u need an options attribute ,and that attribute needs  an array of dictionary with key value pairs of label and value
# this functions returns a value which the user have chosen from the dropdown menu
function return_agency_from_the_dropdown(agency_name)
    lowercased_agency_name = lowercase(agency_name)
    return lowercased_agency_name
end

mongodb_client = authorise_mongodb_connection()

# GLOBAL VARAIBLES
lowercased_agency_name = "all";
#--------------------------------------------LARGE DATA SETS--------------------------------------
TOP_DOMAIN_DATA_DICT = fetch_site_report_data_from_mongodb(lowercased_agency_name,mongodb_client) #this returns a dictionary with keys "monthly_domain_data", "weekly_domain_data", "now_domain_data" which are arrays of dictionaryies with key "domain", "visits"
ALL_PAGES_REALTIME_DATA_DICT = fetch_all_pages_realtime_report_data_from_mongodb(lowercased_agency_name,mongodb_client)
TOP_COUNTRIES_REALTIME_DATA_DICT = fetch_top_countries_realtime_report_data_from_mongodb(lowercased_agency_name,mongodb_client)
TOP_CITIES_REALTIME_DATA_DICT = fetch_top_cities_realtime_report_data_from_mongodb(lowercased_agency_name,mongodb_client )
DOWNLOAD_REPORT_DATA = fetch_download_report_data_from_mongodb(lowercased_agency_name,mongodb_client)
TOP_TRAFFIC_SOURCES_30_DAYS_REPORT_DATA = fetch_top_traffic_sources_30_days_report_data_from_mongodb(lowercased_agency_name,mongodb_client)
#------------------------------------------------LARGE DATA SETS--------------------------------------------

#-----------------------------------FINALISED DATA VARIABLES VALUES---------------------------------
FINAL_TOP_DOMAIN_DATA_DICT = finalise_top_domains(TOP_DOMAIN_DATA_DICT) #returns a dictionary of dictionary -> arrays 
FINAL_WEEKLY_DOMAIN_DATA = FINAL_TOP_DOMAIN_DATA_DICT["final_data_dict_week"]
FINAL_MONTHLY_DOMAIN_DATA = FINAL_TOP_DOMAIN_DATA_DICT["final_data_dict_month"]
FINAL_NOW_PAGES_DATA = FINAL_TOP_DOMAIN_DATA_DICT["final_data_dict_now"]
#-----------------------------------FINALISED DATA VARIABLES VALUES------------------------------------
#global variables






main_content_country_map = nothing;
main_content_city_map = nothing;




tab_styling = Dict("background" => "linear-gradient(90deg, var(#fbc2eb, #f6d365), var(#a6c1ee, #fda085) 51%, var(#fbc2eb, #f6d365)) var(--x, 0)/ 200%;")


header_agency_dropdown_options = fetch_agency_names("agency_dropdown_options");
# header_agency_dropdown_options = [Dict("label" => "apple", "value" => "apple")];

#here we are simply storting and creating the html and css layout for our app

frontend_layout = html_div(children=[
        html_header(
            children=[
                html_img(src="./assets/usagov_logo.png", alt="USA GOV LOGO", className="usagov_logo"),
                html_h1("USA GOVERNMENT WEBSITE ANALYTICS", className="site_heading"),
                dcc_dropdown(options=header_agency_dropdown_options, value=header_agency_dropdown_options[1]["value"], style=Dict("border" => "none", "display" => "flex", "align-items" => "center", "justify-content" => "center", "text-align" => "center", "border-radius" => "40px", "cursor" => "pointer", "color" => "black", "font-family" => "sans-serif"), id="agency_dropdown"),
                html_div(
                    children=[
                        html_a("usa.gov", href="https://usa.gov", className="site_redirect_link")], className="site_redirect_link_container", id="showthis"),
            ], className="content_header"),
        # main section of the page
        html_div(
            children=[
                # left pane things
                html_div(children=[
                        html_h2("Most Popular"),
                        dcc_tabs(children=[
                                dcc_tab(label="Top Domains\n(Past Week)", value="weekly_domains", className="left_pane_tabs_label", style=tab_styling),
                                dcc_tab(label="Top Domains\n(Past Month)", value="monthly_domains", className="left_pane_tabs_label", style=tab_styling),
                                dcc_tab(label="Top Pages\n(Now)", value="pages_now", className="left_pane_tabs_label", style=tab_styling)
                            ], id="left_pane_tabs", value="weekly_domains"), html_div(id="left_pane_graphs", children=[])
                    ], className="left_pane"),
                # right pane things
                html_div(
                    children=[
                        html_div(children=[
                                html_div(children=[
                                    html_div(className="section_one_item"),
                                    html_div(className="section_one_item"),
                                    html_div(className="section_one_item")]),
                                html_div(id="callback_section_one")
                            ], className="right_pane_section_one"),


                        #v whack a moled!
                        html_div(children=[
                                html_div(className="section_two_item"),
                                html_div(className="section_two_item")],
                            className="right_pane_section_two"), html_div(children=[
                                html_div(className="section_three_item"),
                                html_div(className="section_three_item")
                            ], className="right_pane_section_three")],
                    className="right_pane")],
            className="main_content"),#ending of html main_content ,

        # footer section of the page
        html_a(children=[html_footer(children=[
                    html_div(children=[
                        html_p("made with love❣️ by ", style=Dict("display" => "inline")),
                        html_a("hurtbadly", href="https://x.com/hurtbadly2", className="footer_redirect_link", style=Dict("text-decoration" => "none", "display" => "inline"))]),
                    html_img(src="./assets/linktree_logo.png", alt="linktree logo")
                ],
                className="site_footer")#ending of html footer
            ], href="https://linktr.ee/hurtbadly", style=Dict("text-decoration" => "none"))
    ], className="wrapper");#ending of html wrapper ;








Application = dash(external_stylesheets=["./assets/styles.css"]);
Application.title = "usa.gov | Site Analytics";
Application.layout = frontend_layout;




# callbacks related to our application
callback!(Application, Output("showthis", "children"), Input("agency_dropdown", "value")) do selected_agency_option
    lowercased_agency_name = return_agency_from_the_dropdown(selected_agency_option)
    # need to call the function that fetches data for the relevant agency
    TOP_DOMAIN_DATA_DICT = fetch_site_report_data_from_mongodb(lowercased_agency_name) #this returns a dictionary with keys "monthly_domain_data", "weekly_domain_data", "now_domain_data" which are arrays of dictionaryies with key "domain", "visits"
    ALL_PAGES_REALTIME_DATA_DICT = fetch_all_pages_realtime_report_data_from_mongodb(lowercased_agency_name)
    TOP_COUNTRIES_REALTIME_DATA_DICT = fetch_top_countries_realtime_report_data_from_mongodb(lowercased_agency_name)
    TOP_CITIES_REALTIME_DATA_DICT = fetch_top_cities_realtime_report_data_from_mongodb(lowercased_agency_name)
    DOWNLOAD_REPORT_DATA = fetch_download_report_data_from_mongodb(lowercased_agency_name)
    TOP_TRAFFIC_SOURCES_30_DAYS_REPORT_DATA = fetch_top_traffic_sources_30_days_report_data_from_mongodb(lowercase_agency_name)
end




callback!(Application, Output("left_pane_graphs", "children"), Input("left_pane_tabs", "value")) do tab_value
    if tab_value == "weekly_domains"
        FINAL_WEEKLY_DOMAIN_DATA = finalise_top_domains_past_week(TOP_DOMAIN_DATA_DICT["weekly_domain_data"])
        dataset_data_frame = FINAL_WEEKLY_DOMAIN_DATA |> DataFrame
        return dcc_graph(figure=plot(bar(dataset_data_frame, x=:domain, y=:visits, orientation="h")))

    elseif tab_value == "monthly_domains"
        FINAL_MONTHLY_DOMAIN_DATA = finalise_top_domains_past_month(TOP_DOMAIN_DATA_DICT["monthly_domain_data"])
    elseif tab_value == "pages_now"
        FINAL_NOW_PAGES_DATA = finalise_top_pages_now(TOP_DOMAIN_DATA_DICT["now_domain_data"])
    end
end



destroy_mongodb_client(mongodb_client)
run_server(Application, "0.0.0.0", debug=true);




