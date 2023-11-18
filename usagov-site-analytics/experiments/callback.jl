using Pkg;
using Dash;
Pkg.add("PlotlyJS");
using PlotlyJS;
x_values = [1, 2, 3, 4, 5]
y_values = [10, 12, 8, 15, 7]
scatter_plot = scatter(x=x_values, y=y_values, mode="markers", name="Scatter Plot")
# Create a layout
layout = Layout(title="Simple Scatter Plot", xaxis_title="X-axis", yaxis_title="Y-axis")


application = dash();
application.title = "testing dash functionality";


application.layout = html_div(children=[
    dcc_dropdown(id="dropdown_list",options = [Dict("label"=>"option_one","value"=>"value of option one"),
                                               Dict("label"=>"option_two","value"=>"value of option two"),
                                               Dict("label"=>"option_three","value"=>"value of option three")],
                                               value = "value of option two"),
html_h1("value is :"),
html_h1(id="showthis") ,
# Create a plot
html_div(children=[
    dcc_graph(figure = plot(scatter_plot,layout))    
])
]); 
 #here goes all the code that is not to be included within 





function handle_callback(value)
return html_h2(value);
end

# this is the callback that we need to take care of 

callback!(application,Output("showthis","children"),Input("dropdown_list","value")) do selected_value 
handle_callback(selected_value);
end;

run_server(application, "0.0.0.0", debug=true);