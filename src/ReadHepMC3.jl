function read_HepMC3_file(
    HepMC_contents::Vector{String}
)::Vector{Event}
    event_begin_indices =   findall(
        line -> (!isempty(line) && first(line) == 'E'),
        HepMC_contents
    )
    event_end_indices   =   event_begin_indices[2:end] .- 1
    push!(
        event_end_indices,
        findfirst(
            line -> (line == "HepMC::Asciiv3-END_EVENT_LISTING"),
            HepMC_contents
        ) - 1
    )

    event_list  =   (
        (begin_index, end_index) -> (
            read_HepMC3_Event(
                HepMC_contents[begin_index:end_index]
            )
        )
    ).(event_begin_indices, event_end_indices)

    return  event_list
end

function read_HepMC3_Event(event_block::Vector{String})::Event
    @assert (first ∘ first)(event_block) == 'E'

    event_weight    =   (Meta.parse ∘ last ∘ split)(
        event_block[
            findfirst(
                line -> (first(line) == 'W'),
                event_block
            )
        ]
    )

    vertex_indices      =   findall(
        line -> (first(line) == 'V'),
        event_block
    )
    particle_indices    =   findall(
        line -> (first(line) == 'P'),
        event_block
    )

    vertex_list             =   event_block[vertex_indices]
    no_out_particle_list    =   (sort ∘ union)(
        (
            (
                line -> Meta.parse.(
                    split(
                        split(line)[4][begin+1:end-1],
                        ","
                    )
                )
            ).(vertex_list)
        )...
    )
    deleteat!(particle_indices, no_out_particle_list)

    particle_list   =   (
        line -> begin
            split_line  =   split(line)
            tmp         =   Meta.parse.(split_line[4:9])
            Particle(
                tmp[1],
                tmp[2:4],
                tmp[5],
                tmp[6]
            )
        end
    ).(event_block[particle_indices])

    return  Event(
        event_weight,
        particle_list
    )
end