using Pkg

if !haskey(Pkg.installed(),"Dash")
    Pkg.add("Dash")
end

if !haskey(Pkg.installed(),"HTTP")
    Pkg.add("HTTP")
end

if !haskey(Pkg.installed(),"JSON")
    Pkg.add("JSON")
end

if !haskey(Pkg.installed(),"DataFrames")
    Pkg.add("DataFrames")
end

if !haskey(Pkg.installed(),"CSV")
    Pkg.add("CSV")
end


using HTTP
using JSON
using DataFrames
using CSV

## FEEL FREE TO MAKE UR OWN ACCOUNT ON NASDAQ DATA LINK

PERSONAL_API_KEY = "wSs6pJ5fhsqK7HytA_j_"

## you can add your own api key here as well, its free mate 


function fetchYieldCurveData(your_api_key)
    request_url = "https://data.nasdaq.com/api/v3/datasets/USTREASURY/YIELD.json?api_key=$(your_api_key)"
    response = HTTP.get(request_url)
    data_dictionary = JSON.parse(String(response.body))
    
    #data frames stuff 
    dataframes_data = DataFrame(data_dictionary)

    csv_file_name = "yield-curve-data.csv"
    #writing data to a csv file 
    CSV.write(csv_file_name,dataframes_data)

    csv_file_name
end






function format_fetched_csv_data(csv_file_name)
# Read the lines from your CSV file
csv_lines = readlines("yield-curve-data.csv")
csv_lines[1] = ""
# Initialize empty arrays to store extracted data
dates = String[]
values = Vector{Vector{Union{Nothing, Float64}}}()

# Iterate through each line and parse the dictionary
for line in csv_lines
    entry = JSON.parse(line)  # Parse the dictionary from string
    push!(dates, entry["data"][1][1])  # Extract the date
    
    # Extract the values from the "data" array and handle "nothing"
    values_entry = entry["data"][2:end]
    push!(values, values_entry)
end

# Create a DataFrame
column_names = ["1 MO", "2 MO", "3 MO", "6 MO", "1 YR", "2 YR", "3 YR", "5 YR", "7 YR", "10 YR", "20 YR", "30 YR"]
df = DataFrame(Date = dates, values...)
CSV.write("cleaned_data.csv", df)
end
    



#function calls global 

local_csv_file_name = fetchYieldCurveData("wSs6pJ5fhsqK7HytA_j_")
format_fetched_csv_data(local_csv_file_name)