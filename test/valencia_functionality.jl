

using Test
using JetReconstruction

@testset "Valencia Algo Execution" begin
    inputs = JetReconstruction.read_final_state_particles(events_file_ee)
    cluster_seq = jet_reconstruct(inputs[1]; algorithm = JetAlgorithm.Valencia, beta = 1.0, gamma = 1.0, R = 4.0)
    @test cluster_seq isa ClusterSequence{EEJet}
end 

@testset "Valencia Jet Selection" begin
    inputs = JetReconstruction.read_final_state_particles(events_file_ee)
    cluster_seq = jet_reconstruct(inputs[1]; algorithm = JetAlgorithm.Valencia, beta = 1.0, gamma = 1.0, R = 4.0)

    inclusive = inclusive_jets(cluster_seq; ptmin = 1.0)
    @test length(inclusive) >= 0
    for jet in inclusive
        @test jet.pt >= 1.0
    end
end


@testset "Valencia Edge Cases" begin
    empty_event = []
    cluster_seq = jet_reconstruct(empty_event; algorithm = JetAlgorithm.Valencia, beta = 1.0, gamma = 1.0, R = 4.0)
    inclusive = inclusive_jets(cluster_seq; ptmin = 1.0)
    @test length(inclusive) == 0 

    single_particle_event = [EEJet(10.0, 0.0, 5.0, 12.0, 0.0, 0.0, 1)]
    cluster_seq = jet_reconstruct(single_particle_event; algorithm = JetAlgorithm.Valencia, beta = 1.0, gamma = 1.0, R = 4.0)
    inclusive = inclusive_jets(cluster_seq; ptmin = 1.0)
    @test length(inclusive) == 1 
end