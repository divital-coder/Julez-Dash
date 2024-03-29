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


#instantiating intitial top_domain_week_data to not wait for a potential callback input and have delay

function load_initial_top_domain_data_frame(selected_option)
  data = get_domain_data(selected_option, dataframe_dict_array)
  top_domain_display_data_object = top_domains_display_data("", "", Dict(), Dict(), Dict())
  set_properties_top_domains(top_domain_display_data_object, data)
  data_frame_for_plotting_domains = final_top_domain_week_data(top_domain_display_data_object)
  return data_frame_for_plotting_domains
end
global data_frame_for_plotting_domains = load_initial_top_domain_data_frame("all")
println(data_frame_for_plotting_domains)


#########################function for loading location of visitors data from cities and countries
function load_initial_location_of_visitors_data_frame(selected_option, source)

  data = get_location_of_visitors_data(selected_option, dataframe_dict_array)
  location_of_visitors_data_object = location_of_visitors_data("", "")
  set_properties_location_of_visitors(location_of_visitors_data_object, data["top-cities-realtime.json"], data["top-countries-realtime.json"])


  if source == "cities"
    return final_location_of_visitors_from_cities_data_frame(location_of_visitors_data_object)
  elseif source == "countries"
    return final_location_of_visitors_from_countries_data_frame(location_of_visitors_data_object)
  end
end
global data_frame_for_plotting_visitors_from_cities = load_initial_location_of_visitors_data_frame("all", "cities")
global data_frame_for_plotting_visitors_from_countries = load_initial_location_of_visitors_data_frame("all", "countries")
println(data_frame_for_plotting_visitors_from_cities)
println(data_frame_for_plotting_visitors_from_countries)









#################################################function for loading top traffic sources for the past 30 days
function load_initial_top_traffic_sources_30_days_data(selected_option)
  data = get_top_traffic_sources_30_days(selected_option, dataframe_dict_array)
  top_traffic_sources_30_days_data_object = top_traffic_sources_30_days_data("")
  set_properties_top_traffic_sources_30_days(top_traffic_sources_30_days_data_object, data["top-traffic-sources-30-days.json"])
  return final_top_traffic_sources_30_days_data(top_traffic_sources_30_days_data_object)
end
global data_frame_for_plotting_top_traffic_sources = load_initial_top_traffic_sources_30_days_data("all")

traffic_for_users_in_string_array = data_frame_for_plotting_top_traffic_sources[!, :users]
global traffic_for_users_calculation = 0
traffic_for_visits_in_string_array = data_frame_for_plotting_top_traffic_sources[!, :visits]
global traffic_for_visits_calculation = 0

for num in traffic_for_users_in_string_array
  global traffic_for_users_calculation
  traffic_for_users_calculation += tryparse(Int, num)
end
for num in traffic_for_visits_in_string_array
  global traffic_for_visits_calculation
  traffic_for_visits_calculation += tryparse(Int, num)
end
println(data_frame_for_plotting_top_traffic_sources)

###############################################################################################################


function load_initial_all_pages_realtime_data(selected_option)
  data = get_all_pages_realtime_data(selected_option, dataframe_dict_array)
  all_pages_realtime_data_object = all_pages_realtime_data("")
  set_properties_all_pages_realtime(all_pages_realtime_data_object, data["all-pages-realtime.csv"])
  return final_all_pages_realtime_data(all_pages_realtime_data_object)
end
global data_frame_for_plotting_realtime_count = load_initial_all_pages_realtime_data("all")
realtime_active_visitors_string_array = data_frame_for_plotting_realtime_count[!, :active_visitors]
global realtime_active_visitors_calculation = 0

for num in realtime_active_visitors_string_array
  global realtime_active_visitors_calculation
  realtime_active_visitors_calculation += num
end


println(data_frame_for_plotting_realtime_count)




function load_initial_download_data(selected_option)
  data = get_download_data(selected_option, dataframe_dict_array)
  download_data_object = download_data("")
  set_properties_download_data(download_data_object, data["download"])
  return final_download_dataframe(download_data_object)
end

global data_frame_for_plotting_download = load_initial_download_data("all")
println(data_frame_for_plotting_download)









#tab_styling = Dict("background" => "linear-gradient(90deg, var(#fbc2eb, #f6d365), var(#a6c1ee, #fda085) 51%, var(#fbc2eb, #f6d365)) var(--x, 0)/ 200%;")
tab_styling = Dict("background-color" => "#2C3333")

# header_agency_dropdown_options = fetch_agency_names("agency_dropdown_options");

header_agency_dropdown_options = create_header_agency_drop_down_dict_array(capitalised_agency_names_array)
# println(header_agency_dropdown_options)

#here we are simply storting and creating the html and css layout for our app

frontend_layout = html_div(children=[
    html_header(
      children=[
        html_img(src="./assets/usagov_logo.png", alt="USA GOV LOGO", className="usagov_logo"),
        html_h1("USA GOVERNMENT WEBSITE ANALYTICS", className="site_heading"),
        dcc_dropdown(options=header_agency_dropdown_options, value=header_agency_dropdown_options[1]["value"], style=Dict("border" => "none", "display" => "flex", "align-items" => "center", "text-align" => "center", "border-radius" => "40px", "cursor" => "pointer", "color" => "black", "font-family" => "sans-serif", "min-width" => "30rem"), id="agency_dropdown"),
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
            html_div(children=[html_div(children=[
                    html_h2("109090900", id="callback_section_one_item_value_people"),
                    html_p("people on all sites right now"),
                    html_img(src="./assets/icons8-monitor-100.png", className="section_one_item_image")
                  ], className="section_one_item"),
                html_div(children=[
                    html_h2("100", id="callback_section_one_item_value_users"),
                    html_p("total users (past month)"),
                    html_img(src="./assets/icons8-crowd-100.png", className="section_one_item_image")
                  ], className="section_one_item"),
                html_div(children=[html_h2("100", id="callback_section_one_item_value_visits"),
                    html_p("total visits (past month)"),
                    html_img(src="./assets/icons8-eye-100.png", className="section_one_item_image")
                  ], className="section_one_item")
              ], className="right_pane_section_one"),


            #v whack a moled!
            html_div("TRAFFIC BREAKDOWN", className="traffic_breakdown_heading"),
            html_div(children=[
                html_div(children=[
                  ], id="geo_scatter_plot_cities", className="section_two_item"),
                html_div(children=[
                  ], id="geo_scatter_plot_countries", className="section_two_item")],
              className="right_pane_section_two"), html_div("TOP DOWNLOADS", className="top_downloads_heading"),
            html_div(children=[
                html_div(children=[
                  ], id="download_data_plot", className="section_three_item")
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
      ], href="https://linktr.ee/hurtbadly", style=Dict("text-decoration" => "none")), html_div(id="dummy_output_container", style=Dict("display" => "none"))
  ], className="wrapper");#ending of html wrapper ;








Application = dash(external_stylesheets=["./assets/styles.css"]);
Application.title = "usa.gov | Site Analytics";
Application.layout = frontend_layout;




# callbacks related to our application
callback!(Application, Output("download_data_plot", "children"), Output("geo_scatter_plot_cities", "children"), Output("geo_scatter_plot_countries", "children"), Output("callback_section_one_item_value_people", "children"), Output("callback_section_one_item_value_users", "children"), Output("callback_section_one_item_value_visits", "children"), Output("dummy_output_container", "children"), Input("agency_dropdown", "value")) do selected_agency_option
  global data_frame_for_plotting_domains
  data_frame_for_plotting_domains = load_initial_top_domain_data_frame(selected_agency_option)
  println(data_frame_for_plotting_domains)
  #instantiating final stuff


  ####################################################################################################################

  global data_frame_for_plotting_visitors_from_cities
  global data_frame_for_plotting_visitors_from_countries
  data_frame_for_plotting_visitors_from_cities = load_initial_location_of_visitors_data_frame(selected_agency_option, "cities")
  data_frame_for_plotting_visitors_from_countries = load_initial_location_of_visitors_data_frame(selected_agency_option, "countries")

  println(data_frame_for_plotting_visitors_from_cities)
  println(data_frame_for_plotting_visitors_from_countries)

  ############################################################################################################################
  global data_frame_for_plotting_top_traffic_sources
  data_frame_for_plotting_top_traffic_sources = load_initial_top_traffic_sources_30_days_data(selected_agency_option)
  println(data_frame_for_plotting_top_traffic_sources)

  global traffic_for_visits_calculation
  traffic_for_visits_calculation = 0
  traffic_for_visits_in_string_array = data_frame_for_plotting_top_traffic_sources[!, :visits]
  for num in traffic_for_visits_in_string_array
    traffic_for_visits_calculation += tryparse(Int, num)
  end

  global traffic_for_users_calculation
  traffic_for_users_calculation = 0
  traffic_for_users_in_string_array = data_frame_for_plotting_top_traffic_sources[!, :users]
  for num in traffic_for_users_in_string_array
    traffic_for_users_calculation += tryparse(Int, num)
  end

  #################################################################################################################################

  global realtime_active_visitors_calculation
  global data_frame_for_plotting_realtime_count
  data_frame_for_plotting_realtime_count = load_initial_all_pages_realtime_data(selected_agency_option)

  realtime_active_visitors_string_array = data_frame_for_plotting_realtime_count[!, :active_visitors]
  realtime_active_visitors_calculation = 0
  for num in realtime_active_visitors_string_array
    global realtime_active_visitors_calculation
    realtime_active_visitors_calculation += num
  end







  cities_graph_figure = plot(bar(x=["apple", "mango"], y=[100, 200], orientation="h"), Layout(height=300, width=500))
  graph_plot_for_cities = dcc_graph(figure=cities_graph_figure)







  countries = ["USA", "Canada", "India", "UK"]
  latitudes = [37.0902, 56.1304, 20.5937, 51.5099]
  longitudes = [-95.7129, -106.3468, 78.9629, -0.1180]

  # Create scatter geo map
  trace = scattermapbox(
    lat=latitudes,
    lon=longitudes,
    mode="markers", text=countries,
  )

  layout = Layout(
    mapbox=attr(
      style="carto-darkmatter",
      center=attr(lat=30, lon=0),
      zoom=1,
      borderwidth=0,
      padding=0,
      
    ),
    margin=attr(l=0, r=0, b=0, t=0)
  )

  countries_graph_figure = plot(trace, layout)
  graph_plot_for_countries = dcc_graph(figure=countries_graph_figure, style=Dict("padding" => "0px", "border" => "none","width"=>"400px","height"=>"400px"))


  global data_frame_for_plotting_download
  data_frame_for_plotting_download = load_initial_download_data(selected_agency_option)
  download_graph_figure = plot(bar(x=data_frame_for_plotting_download[!, :total_events], y=data_frame_for_plotting_download[!, :page_title], orientation="h", marked_color="blue"))
  graph_plot_for_download = dcc_graph(figure=download_graph_figure)
  return (graph_plot_for_download, graph_plot_for_cities, graph_plot_for_countries, realtime_active_visitors_calculation, traffic_for_users_calculation, traffic_for_visits_calculation, "")
end




callback!(Application, Output("left_pane_graphs", "children"), Input("left_pane_tabs", "value")) do tab_value
  global data_frame_for_plotting_domains

  plot_figure = nothing
  if tab_value == "weekly_domains" || tab_value == "monthly_domains"
    plot_figure = plot(bar(x=data_frame_for_plotting_domains[!, :visits],
        y=data_frame_for_plotting_domains[!, :domain],
        marked_color="blue",
        orientation="h"
      ), Layout(height=800, width=600, barmode="overlay")
    )
  else
    plot_figure = plot(bar(x=data_frame_for_plotting_domains[!, :visits],
        y=data_frame_for_plotting_domains[!, :domain],
        marked_color="blue", orientation="h"),
      Layout(height=800, width=600, barmode="overlay")
    )
  end
  return dcc_graph(figure=plot_figure, style=Dict("padding" => "0px", "margin-top" => "2rem", "border-radius" => "12px"))
end



run_server(Application, "0.0.0.0", debug=true);



