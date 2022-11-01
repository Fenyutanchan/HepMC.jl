function read_HepMC_file(file_name::String)::Vector{Event}
    @assert (last ∘ splitext)(file_name) == ".hepmc"

    HepMC_contents  =   readlines(file_name)

    HepMC_version   =   (VersionNumber ∘ last ∘ split)(
        HepMC_contents[findfirst(!isempty, HepMC_contents)]
    )

    if HepMC_version.major  ==  2
        return  read_HepMC2_file(HepMC_contents)
    elseif HepMC_version.major == 3
        return  read_HepMC3_file(HepMC_contents)
    else
        throw("HepMC version error.")
    end
end