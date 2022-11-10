function read_events_JLD2(file_name::String, index::String)::Event
    @assert splitext(file_name)[end] == ".jld2"

    jld_file    =   jldopen(file_name, "r")
    jld_keys    =   keys(jld_file)

    @assert index ∈ jld_keys
    event   =   Event(jld_file[index])

    close(jld_file)
    return  event
end
read_events_JLD2(file_name::String, index::Int)::Event  =   read_events_JLD2(
    file_name, "$index"
)
function read_events_JLD2(file_name::String)::Vector{Event}
    @assert splitext(file_name)[end] == ".jld2"

    jld_file    =   jldopen(file_name, "r")
    jld_keys    =   sort(Meta.parse.(keys(jld_file)))
    event_list  =   Event[Event(jld_file["$key"]) for key ∈ jld_keys]
    close(jld_file)
    
    return event_list
end

function write_events_JLD2(file_name::String, event_list::Vector{Event})::Nothing
    if splitext(file_name)[end] != ".jld2"
        file_name   *=  ".jld2"
    end

    file_content    =   Dict{String, Dict}()
    for ii ∈ eachindex(event_list)
        file_content["$ii"]    =   Dict(event_list[ii])
    end
    save(file_name, file_content)
    return  nothing
end