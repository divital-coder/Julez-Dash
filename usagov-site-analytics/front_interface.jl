using Pkg;
Pkg.add("Dash"); #this enables us to launch our web app
Pkg.add("PlotlyJS"); #this enables us to create plots and graphs
Pkg.update();

include("./data_retrieve.jl")
include("./front_data_manipulation.jl")
using Dash;
using PlotlyJS;

#for dropdowns u need an options attribute ,and that attribute needs  an array of dictionary with key value pairs of label and value
# this functions returns a value which the user have chosen from the dropdown menu
#--------------------------------------------LARGE DATA SETS--------------------------------------

#------------------------------------------------LARGE DATA SETS--------------------------------------------

#-----------------------------------FINALISED DATA VARIABLES VALUES---------------------------------

#-----------------------------------FINALISED DATA VARIABLES VALUES------------------------------------
#global variables
global data_frame_for_plotting = nothing








#tab_styling = Dict("background" => "linear-gradient(90deg, var(#fbc2eb, #f6d365), var(#a6c1ee, #fda085) 51%, var(#fbc2eb, #f6d365)) var(--x, 0)/ 200%;")
tab_styling = Dict("background-color"=>"#2C3333")

# header_agency_dropdown_options = fetch_agency_names("agency_dropdown_options");

header_agency_dropdown_options = create_header_agency_drop_down_dict_array(capitalised_agency_names_array)
# println(header_agency_dropdown_options)

#here we are simply storting and creating the html and css layout for our app

frontend_layout = html_div(children=[
        html_header(
            children=[
                html_img(src="./assets/usagov_logo.png", alt="USA GOV LOGO", className="usagov_logo"),
                html_h1("USA GOVERNMENT WEBSITE ANALYTICS", className="site_heading"),
                dcc_dropdown(options=header_agency_dropdown_options, value=header_agency_dropdown_options[1]["value"], style=Dict("border" => "none", "display" => "flex", "align-items" => "center", "justify-content" => "center", "text-align" => "center", "border-radius" => "40px", "cursor" => "pointer", "color" => "black", "font-family" => "sans-serif"), id="agency_dropdown"),
                html_div(
                    children=[
                        html_a("usa.gov", href="https://usa.gov", className="site_redirect_link")], className="site_redirect_link_container", id="showthis")
            ], className="content_header"),
        # main section of the page
        html_div(
            children=[
                # left pane things
                html_div(children=[
                        html_h2("Most Popular", className="left_pane_heading"),
                        dcc_tabs(children=[
                                dcc_tab(label="Top Domains\n(Past Week)", value="weekly_domains", className="left_pane_tabs_label", style=tab_styling),
                                dcc_tab(label="Top Domains\n(Past Month)", value="monthly_domains", className="left_pane_tabs_label", style=tab_styling),
                                dcc_tab(label="Top Pages\n(Now)", value="pages_now", className="left_pane_tabs_label", style=tab_styling)
                            ], id="left_pane_tabs", value="weekly_domains"), 
                            html_div(id="left_pane_graphs", children=[])
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
callback!(Application, Output("dummy", "children"), Input("agency_dropdown", "value")) do selected_agency_option
    data = get_domain_data(selected_agency_option, dataframe_dict_array)
    #instantiating final stuff
    top_domains_display_data_object = top_domains_display_data("", "", Dict(), Dict(), Dict())
    set_properties_top_domains(top_domains_display_data_object, data)
    println(final_top_domain_week_data(top_domains_display_data_object))
    
   return ""
end




callback!(Application, Output("left_pane_graphs", "children"), Input("left_pane_tabs", "value")) do tab_value
    global data_frame_for_plotting
    plot_this = plot(data_frame_for_plotting)
    println(data_frame_for_plotting)
    return dcc_graph(figure=plot_this)
end



run_server(Application, "0.0.0.0", debug=true);




