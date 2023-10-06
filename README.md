# Simpson

[![Build Status](https://github.com/youwuyou/Simpson.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/youwuyou/Simpson.jl/actions/workflows/CI.yml?query=branch%3Amain)

This is a repository for demonstration purpose of how to wrap a C++ library and use it in Julia.








## Source C++ library

The source C++ library needs to have a C API implemented for exporting C++ functions. Besides of this, it needs no special modifications.

- `simpson/include/c_api.h`

- `simpson/src/c_api.cpp`

## Structure

```bash
Simpson.jl
├── example
├── LICENSE
├── Manifest.toml
├── Project.toml
├── README.md
├── res         #
│   ├── Manifest.toml
│   ├── Project.toml
│   ├── prologue.jl
│   ├── wrap.jl
│   └── wrap.toml
├── src         #
│   ├── api.jl
│   └── Simpson.jl
└── test        # 
    ├── assets
    ├── runtests.jl
    └── test_integration1D.jl


```




## Testing

A example unit test is provided, make sure you are in the project environment when accessing interactive shell using `julia --project`. Then execute test within the package environment and run `test`

```shell
$ julia --project
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.9.1 (2023-06-07)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> ]
(Simpson) pkg>
(Simpson) pkg> test
```

The following output is expected

```julia
     Testing Running tests...
Test Summary:                               | Pass  Total  Time
Reference test: simpson integration rule 1D |    1      1  0.0s
```