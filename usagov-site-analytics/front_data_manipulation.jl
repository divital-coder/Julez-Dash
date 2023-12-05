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
   return first(top_domain_site_data_frame,5)
end
# final_top_domain_month_data()
# final_top_domain_now_data()
