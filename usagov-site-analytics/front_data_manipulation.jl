using Pkg;

# left pane data 
# weekly_domain_data
function finalise_top_domains_past_week(top_domain_data)
    final_data_array = [];
    for num in 1:100
        data_object = [];
        push!(data_object,String(top_domain_data["weekly_domain_data"][num]["domain"]));
        push!(data_object,Int(top_domain_data["weekly_domain_data"][num]["visits"]))
        push!(final_data_array,data_object);
    end
    return final_data_array; #returns array=>array [[domain,1312312]]
end
# monthly_domain_data
function finalise_top_domains_past_month(top_domain_data)
    final_data_array = [];
    for num in 1:100
    data_object = [];
    push!(data_object,String(top_domain_data["monthly_domain_data"][num]["domain"]));
    push!(data_object,Int(top_domain_data["monthly_domain_data"][num]["visits"]));
    push!(final_data_array,data_object);
    end
    return final_data_array;
end
# now_domain_data
function finalise_top_pages_now(top_pages_now_data)
    final_data_array = [];
    for num in 1:100
    data_object = [];
    push!(data_object,String(top_domain_data["now_domain_data"][num]["domain"]));
    push!(data_object,Int(top_domain_data["now_domain_data"][num]["visits"]));
    push!(final_data_array, data_object);
    end
    return final_data_array;
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
