module  HepMC

    using   JLD2
    using   StructParticle

    include("Read.jl")
    include("ReadHepMC2.jl")
    include("ReadHepMC3.jl")

end # module HepMC
