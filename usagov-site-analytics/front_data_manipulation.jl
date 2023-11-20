using Pkg;

# left pane data
# weekly_domain_data
function finalise_top_domains_past_week(top_domain_data)
    final_data_dict = Dict()
    if length(top_domain_data["weekly_domain_data"]) > 100
        for num in 0:100
            final_data_dict[String(top_domain_data["weekly_domain_data"][num]["domain"])] = Int(top_domain_data["weekly_domain_data"][num]["visits"])
        end

    elseif length(top_domain_data["weekly_domain_data"]) < 100
        for num in 0:length(top_domain_data["weekly_domain_data"])
            final_data_dict[String(top_domain_data["weekly_domain_data"][num]["domain"])] = Int(top_domain_data["weekly_domain_data"][num]["visits"])
        end
    elseif haskey(top_domain_data["weekly_domain_data"], "dummy_data_value")
        final_data_dict["dummy_domain_value"] = 0

    end

    return final_data_dict#returns array=>array [[domain,1312312]]
end
# monthly_domain_data
function finalise_top_domains_past_month(top_domain_data)
    final_data_dict = Dict()
    if length(top_domain_data) > 100
        for num in 0:100
            final_data_dict[String(top_domain_data["monthly_domain_data"][num]["domain"])] = Int(top_domain_data["monthly_domain_data"][num]["visits"])
        end
    elseif length(top_domain_data) < 100
        for num in 0:length(top_domain_data)
            final_data_dict[String(top_domain_data["monthly_domain_data"][num]["domain"])] = Int(top_domain_data["monthly_domain_data"][num]["visits"])
        end
    elseif haskey(top_domain_data["monthly_domain_data"], "dummy_data_value")
        final_data_dict["dummy_domain_value"] = 0
    end

    return final_data_dict
end
# now_domain_data
function finalise_top_pages_now(top_pages_now_data)
    final_data_dict = Dict()

    if length(top_domain_data["now_domain_data"]) > 100
        for num in 0:100
            final_data_dict[String(top_pages_now_data["now_domain_data"][num]["domain"])] = Int(top_domain_data["now_domain_data"][num]["visits"])
        end

    elseif length(top_domain_data["now_domain_data"]) < 100
        for num in 0:length(top_domain_data)
            final_data_dict[String(top_pages_now_data["now_domain_data"][num]["domain"])] = Int(top_domain_data["now_domain_data"][num]["visits"])
        end

    elseif haskey(top_domain_data["now_domain_data"], "dummy_data_value")
        final_data_dict["dummy_domain_value"] = 0
    end

    return final_data_dict
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
