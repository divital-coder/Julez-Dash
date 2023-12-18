using Pkg;
Pkg.add("Dates");
using Dates;
mutable struct top_domains_display_data
  top_domain_site_data_frame
  top_domain_realtime_data_frame

  top_domain_week_data
  top_domain_month_data
  top_domain_now_data
end

set_properties_top_domains(object::top_domains_display_data, data) = begin
  object.top_domain_site_data_frame = data["site"]
  object.top_domain_realtime_data_frame = data["all-pages-realtime.csv"]
end

final_top_domain_week_data(object::top_domains_display_data) = begin
  top_domain_week_data_dict = Dict()
  top_domain_site_data_frame = object.top_domain_site_data_frame

  current_date = Dates.today()
  past_week_date = current_date - Dates.Day(6)
  return first(top_domain_site_data_frame, 20)
end
# final_top_domain_month_data()
# final_top_domain_now_data()
#
#
#
#
#
#
#
#
#
#
#
#

mutable struct location_of_visitors_data
  location_of_visitors_from_cities_data_frame
  location_of_visitors_from_countries_data_frame
end

set_properties_location_of_visitors(object::location_of_visitors_data, location_from_cities_data_frame, location_from_countries_data_frame) = begin
  object.location_of_visitors_from_cities_data_frame = location_from_cities_data_frame
  object.location_of_visitors_from_countries_data_frame = location_from_countries_data_frame
end

final_location_of_visitors_from_cities_data_frame(object::location_of_visitors_data) = begin
  location_of_visitors_from_cities_data_frame = object.location_of_visitors_from_cities_data_frame
  return first(location_of_visitors_from_cities_data_frame, 20)

end

final_location_of_visitors_from_countries_data_frame(object::location_of_visitors_data) = begin
  location_of_visitors_from_countries_data_frame = object.location_of_visitors_from_countries_data_frame
  return first(location_of_visitors_from_countries_data_frame, 20)
end


#####################################################################################################################33









mutable struct top_traffic_sources_30_days_data
  top_traffic_sources_30_days_dataframe
end
set_properties_top_traffic_sources_30_days(object::top_traffic_sources_30_days_data, traffic_sources_30_days_data_frame) = begin
  object.top_traffic_sources_30_days_dataframe = traffic_sources_30_days_data_frame
end

final_top_traffic_sources_30_days_data(object::top_traffic_sources_30_days_data) = begin
  top_traffic_sources_30_days_dataframe = object.top_traffic_sources_30_days_dataframe
  #we cannnot just returns the first 20 entries since all numbers are needed to calculate the total for displaying the stuff on front page
  return top_traffic_sources_30_days_dataframe
end

##################################################################################
#
#


mutable struct all_pages_realtime_data
  all_pages_realtime_dataframe
end
set_properties_all_pages_realtime(object::all_pages_realtime_data, all_pages_realtime_dataframe) = begin
  object.all_pages_realtime_dataframe = all_pages_realtime_dataframe
end
final_all_pages_realtime_data(object::all_pages_realtime_data) = begin
  all_pages_realtime_dataframe = object.all_pages_realtime_dataframe
  return all_pages_realtime_dataframe
end



mutable struct download_data
download_dataframe
end
set_properties_download_data(object::download_data, download_dataframe) = begin
object.download_dataframe = download_dataframe
end
final_download_dataframe(object::download_data) = begin
download_dataframe = object.download_dataframe
  return download_dataframe
end
















