using Pkg;

# left pane data
# weekly_domain_data
function finalise_top_domains(top_domain_data)
    final_data_dict = Dict()


    final_data_dict_week = Dict()
# finalising top_domains_past_week
    if length(top_domain_data["weekly_domain_data"]) > 100
        for num in 1:100
            final_data_dict_week[String(top_domain_data["weekly_domain_data"][num]["domain"])] = Int(top_domain_data["weekly_domain_data"][num]["visits"])
                #in the above function we loop over a dict->array->dict (since arrays start at 1 u have to catch up)
        end

    elseif length(top_domain_data["weekly_domain_data"]) < 100
        for num in 1:length(top_domain_data["weekly_domain_data"])
            final_data_dict_week[String(top_domain_data["weekly_domain_data"][num]["domain"])] = Int(top_domain_data["weekly_domain_data"][num]["visits"])
        end
    elseif haskey(top_domain_data["weekly_domain_data"], "dummy_data_value")
        final_data_dict_week["dummy_domain_value"] = 0

    end
#finalised_top_domains_past_week

final_data_dict_month = Dict()
#finalise top domains past month
if length(top_domain_data["monthly_domain_data"]) > 100
    for num in 1:100
        final_data_dict_month[String(top_domain_data["monthly_domain_data"][num]["domain"])] = Int(top_domain_data["monthly_domain_data"][num]["visits"])
    end
elseif length(top_domain_data["monthly_domain_data"]) < 100
    for num in 1:length(top_domain_data)
        final_data_dict_month[String(top_domain_data["monthly_domain_data"][num]["domain"])] = Int(top_domain_data["monthly_domain_data"][num]["visits"])
    end
elseif haskey(top_domain_data["monthly_domain_data"], "dummy_data_value")
    final_data_dict_month["dummy_domain_value"] = 0
end
#finalised top domains past month 

final_data_dict_now = Dict()
#finalise now pages data
if length(top_domain_data["now_domain_data"]) > 100
    for num in 1:100
        final_data_dict_now[String(top_pages_now_data["now_domain_data"][num]["domain"])] = Int(top_domain_data["now_domain_data"][num]["visits"])
    end

elseif length(top_domain_data["now_domain_data"]) < 100
    for num in 1:length(top_domain_data)
        final_data_dict_now[String(top_pages_now_data["now_domain_data"][num]["domain"])] = Int(top_domain_data["now_domain_data"][num]["visits"])
    end

elseif haskey(top_domain_data["now_domain_data"], "dummy_data_value")
    final_data_dict_now["dummy_domain_value"] = 0
end
#finalise now pages data


    final_data_dict["final_data_dict_week"] = final_data_dict_week
    final_data_dict["final_data_dict_month"] = final_data_dict_month
    final_data_dict["final_data_dict_now"] = final_data_dict_now
    return final_data_dict#returns array=>array [[domain,1312312]]
end



function finalise_top_cities_realtime()
    nothing
end

function finalist_top_countries_realtime()
    nothing
end

function finalise_top_downloads_yesterday()
    nothing
end
