using Pkg

##Install required if packages not installed already : 
if !haskey(Pkg.installed(),"Dash" ) 
        Pkg.add("Dash")
end
if !haskey(Pkg.installed(),"WebIO")
    Pkg.add("WebIO")
end
if !haskey(Pkg.installed(),"Blink")
    Pkg.add("Blink")
end

if !haskey(Pkg.installed(),"HTTP")
    Pkg.add("HTTP")
end





#installation necessary if packages not already installed 

using Dash 
using WebIO
using Blink
using HTTP

application = dash(meta_tags = [Dict("name"=>"viewport", "width"=>"width=device-width")])
application.title = "Yield Curve Analysis"



application.layout = html_div(
    [
    dcc_store(id="click-output"),
    html_div(
        [
            html_div(
                    [
                    dcc_markdown("untouchables", className="mainheadin"),
                    dcc_graph(style=Dict("margin"=>"0 20px", "height"=>"45vh" ))
                    ]
            ) 
        ]
    )
    ]
)

run_server(application,"0.0.0.0", 8050,debug=true)



