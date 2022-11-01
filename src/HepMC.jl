module  HepMC

    using   StructParticle

    export  read_HepMC_file

    include("Read.jl")
    include("ReadHepMC2.jl")
    include("ReadHepMC3.jl")

end # module HepMC
