module  HepMC

    using   JLD2
    using   StructParticle

    export  read_HepMC_file
    export  read_events_JLD2, write_events_JLD2

    include("Read.jl")
    include("ReadHepMC2.jl")
    include("ReadHepMC3.jl")

    include("ForJLD2.jl")

end # module HepMC
