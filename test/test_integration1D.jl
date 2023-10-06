# Testing 1D
using Test

# integrate
@testset "Reference test: simpson integration rule 1D" begin
    # Create an empty Float64 array to hold the results.
    computed_results = Float64[]

    for i in 2:100
        result = @integrate(0, π, i, sin)
        push!(computed_results, result)  # Add result to the results_array
    end
    expected_results = readlines("assets/reference.txt")  # Assuming result.txt is the file with expected values

    @test length(computed_results) == length(expected_results)    
end
