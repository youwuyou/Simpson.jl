using Simpson

# dummy function to check API is working
get_version()

# main function calculating the integral
function main(;default_input=false, N = 100)
    println("Integrator maximum resolution?")
    
    if !default_input
        N = tryparse(UInt, readline())
    end

    
    if N === nothing
        println("Invalid input. Please enter a non-negative integer.")
        return
    end
    
    println(N)
    
    open("results.txt", "w") do of
        for i in 2:N
            result = @integrate(0, π, i, sin)
            result_str = string(i, "\t", round(result, digits=5))  # formatting result to 5 decimal places
            println(of, result_str)  # printing formatted string to file
        end
    end
end

if isinteractive()
    main()
end
