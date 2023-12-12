include("./data_stuff.jl")


mongodb_client = initiate_connection(mongodb_object)
string_data_dict_array = retrieve_data_from_mongodb(mongodb_object, mongodb_client)
requested_data_object = Requested_dataframe_dict_array([], [])
dataframe_dict_array = set_dataframe_dict_array(requested_data_object, string_data_dict_array)



#checking things

check_data_frame() = begin
  for agency_dict in dataframe_dict_array
    for (key, value) in agency_dict
      if key != "id"
        println(value)
      end
    end
  end
end
# check_data_frames()


#creates a dictionary with label values for header dropdown
create_header_agency_drop_down_dict_array(agency_names) = begin
  header_agency_dict_array = []
  for agency_name in agency_names
    data_dict = Dict("label" => agency_name, "value" => agency_name)
    push!(header_agency_dict_array, data_dict)
  end
  return header_agency_dict_array
end



#handle top domains data  week, month, realtime
#for week and month use site report
#for realtime use all-pages-realtime.csv report

get_domain_data(id, data) = begin
  site_dataframe_dict = Dict()
  for data_frame_dict in data
    if data_frame_dict["id"] == lowercase(id)
      site_dataframe_dict["site"] = data_frame_dict["site"]
      site_dataframe_dict["all-pages-realtime.csv"] = data_frame_dict["all-pages-realtime.csv"]
    end
  end
  return site_dataframe_dict
end

#domains , visits

get_location_of_visitors_data(id, data) = begin
  location_of_visitors_dataframe_dict = Dict()
  for data_frame_dict in data
    if data_frame_dict["id"] == lowercase(id)
      location_of_visitors_dataframe_dict["top-cities-realtime.json"] = data_frame_dict["top-cities-realtime.json"]
      location_of_visitors_dataframe_dict["top-countries-realtime.json"] = data_frame_dict["top-countries-realtime.json"]
    end

  end
  return location_of_visitors_dataframe_dict

end


get_download_data(id, data) = begin
  download_dataframe_dict = Dict()
  for data_frame_dict in data
    if data_frame_dict["id"] == lowercase(id)
      download_dataframe_dict["download"] = data_frame_dict["download"]
    end
  end
  return download_dataframe_dict
end

get_top_traffic_sources_30_days(id,data) = begin
  top_traffic_sources_30_days_dataframe_dict = Dict()
  for data_frame_dict in data
    if data_frame_dict["id"] == lowercase(id)
      top_traffic_sources_30_days_dataframe_dict["top-traffic-sources-30-days.json"]= data_frame_dict["top-traffic-sources-30-days.json"]
    end
  end
  return top_traffic_sources_30_days_dataframe_dict
end


get_all_pages_realtime_data(id,data) = begin
  all_pages_realtime_dataframe_dict = Dict()
  for data_frame_dict in data
    if data_frame_dict["id"] == lowercase(id)
      all_pages_realtime_dataframe_dict["all-pages-realtime.csv"] = data_frame_dict["all-pages-realtime.csv"]
    end
  end
  return all_pages_realtime_dataframe_dict
end








