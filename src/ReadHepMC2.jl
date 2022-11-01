function read_HepMC2_file(
    HepMC_contents::Vector{String}
)::Vector{Event}
    event_begin_indices =   findall(
        line -> (!isempty(line) && first(line) == 'E'),
        HepMC_contents
    )
    event_end_indices   =   event_begin_indices[2:end] .- 1
    push!(event_end_indices, length(HepMC_contents) - 1)

    num_event   =   length(event_begin_indices)

    event_list  =   Event[]
    for ii ∈ 1:num_event
        this_event_begin_index  =   event_begin_indices[ii]
        this_event_end_index    =   event_end_indices[ii]

        # for event information
        this_event_info =   split(
            HepMC_contents[this_event_begin_index]
        )
        @assert first(this_event_info) == "E"
        this_event_info =   Meta.parse.(this_event_info[2:end])
        # @assert first(this_event_info) == ii - 1
        this_num_vertex =   this_event_info[8]
        @assert this_event_info[9] == 1 && this_event_info[10] == 2
        @assert this_event_info[11] == 0
        @assert this_event_info[12] == 1
        @assert length(this_event_info) == 13
        this_event_weight   =   last(this_event_info)
        # end for event information

        # useless lines
        @assert first(
            HepMC_contents[
                this_event_begin_index + 1
            ]
        ) == 'N'
        @assert first(
            HepMC_contents[
                this_event_begin_index + 2
            ]
        ) == 'U'
        @assert first(
            HepMC_contents[
                this_event_begin_index + 3
            ]
        ) == 'C'
        # end useless lines

        num_particle_in_vertex  =   0
        this_particle_list      =   Particle[]
        for line ∈ HepMC_contents[(this_event_begin_index+4):this_event_end_index]
            # @show num_particle_in_vertex
            if first(line) == 'V'
                # @show line
                @assert num_particle_in_vertex == 0
                num_particle_in_vertex  =   sum(Meta.parse.(split(line)[8:9]))
                this_num_vertex -=  1
                continue
            end

            @assert first(line) == 'P'
            num_particle_in_vertex  -=  1
            content =   Meta.parse.(split(line)[2:end])
            if content[11] != 0
                @assert content[11] < 0
                continue
            end
            push!(
                this_particle_list,
                Particle(
                    content[2],
                    content[3:5],
                    content[6],
                    content[7]
                )
            )
        end
        @assert num_particle_in_vertex == 0

        push!(
            event_list,
            Event(
                this_event_weight,
                this_particle_list
            )
        )
    end
    return  event_list
end