module API

using CEnum

# Prologue can be added under /res/prologue.jl
import simpson_jll: libsimpson

"""
    simpson_integrate(a, b, bins, _function)

This function is a wrapper around integrate function in simpson library

### Parameters
* `a`: real number
* `b`: real number
* `bins`: positive integer
* `function`: function pointer to the function that is integrated over
### Returns
double result as a real number
"""
function simpson_integrate(a, b, bins, _function)
    ccall((:simpson_integrate, libsimpson), Cdouble, (Cdouble, Cdouble, Cuint, Ptr{Cvoid}), a, b, bins, _function)
end

# no prototype is found for this function at c_api.h:31:8, please use with caution
"""
    simpson_get_version()

This function is a wrapper for obtaining the version of the simpson library
"""
function simpson_get_version()
    ccall((:simpson_get_version, libsimpson), Cvoid, ())
end

# exports
const PREFIXES = ["CX", "clang_"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
