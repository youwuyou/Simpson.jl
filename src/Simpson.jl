module Simpson

# Write your package code here.
include("api.jl")

# Export high-level API functions
export get_version

# Export high-level Macros
export @integrate

"""
    locate()

Locate the Simpson library currently being used, by Simpson.jl
"""
locate() = API.simpson_jll.get_libsimpson_path()


# Example 1: get version number
function get_version()
    API.simpson_get_version()
end

# Example 2: integrate leveraging meta programming
macro integrate(a, b, bins, f) 
    quote
        c_callback = @cfunction($f, Cdouble, (Cdouble,))
        API.simpson_integrate($a, $b, $(esc(bins)), c_callback)
    end
end

end
