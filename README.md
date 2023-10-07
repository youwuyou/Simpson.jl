# Simpson.jl

[![Build Status](https://github.com/youwuyou/Simpson.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/youwuyou/Simpson.jl/actions/workflows/CI.yml?query=branch%3Amain)

This is a repository for demonstration purpose of how to wrap a C++ library and use it in Julia. We created C API interface for a library called [simpson](https://github.com/youwuyou/simpson) and wrapped it into the `Simpson.jl` package we have here, while artifacts needed for interfacing between C++ and Julia code are stored under [simpson_jll.jl](https://github.com/youwuyou/simpson_jll.jl) package.


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


## A guide to creating Julia wrapper package


>1. C++ library which contains a C API
>2. Artifacts of the C++ library stored in a JLL package
>3. Autogeneration of a low-level Julia API `api.jl` containing `ccall` to C++ functions using artifacts
>4. Implementation of a high-level Julia API


###1. Source C++ library

The source C++ library needs to have a C API implemented for exporting C++ functions. Besides of this, it needs no special modifications.

- `simpson/include/c_api.h`

- `simpson/src/c_api.cpp`

Besides of these, no other modifications need to be done.


###2. Managing Artifacts

For dynamic linker of Julia to be able to use C++ code we have written, we need to compile our C++ library into a **`.so` file** as a shared library. Additionally, we also need the **C API header** `c_api.h` to tell the linker necessary information such as which symbols it should look up and at which line of the compiled binary file the function to be executed resides.

#### Using JLL package as users

In Julia community, these artifacts are stored under individual `JLL` package. Under the [JuliaBinaryWrappers organization](https://github.com/JuliaBinaryWrappers), you could find a lot of existing packages with source code in other languages being hosted there. 

#### Creating JLL package as developers

In order to create such `JLL` packages, you firstly need to use [BinaryBuilder.jl](https://github.com/JuliaPackaging/BinaryBuilder.jl) to create a `build_tarballs.jl` file that contains build instructions for your specific library. One can refer to the [BinaryBuilder tutorial](https://docs.binarybuilder.org/stable/) for details. Then we can now use the created script to automate the process for building artifacts targeting different platforms.

There are mainly two ways to deploy your project.

> 1. [Submitting the build script to Yggdrasil](https://docs.binarybuilder.org/stable/#Wizard-interface) and host the built artifacts under JuliaBinaryWrappers organization. 

> 2. Publish your build script locally under your github account [without going through Ygdrasil](https://docs.binarybuilder.org/stable/FAQ/#Can-I-publish-a-JLL-package-locally-without-going-through-Yggdrasil).

In general, projects submitted to Yggdrasil here should be relevant to many users. So in our case we would choose the latter option and deploy the JLL package [simpson_jll.jl](https://github.com/youwuyou/simpson_jll.jl) locally.



###3. Autogeneration using [Clang.jl](https://github.com/JuliaInterop/Clang.jl)

Next, we need to use `Clang.jl` for generating low-level API that contains `ccall` to C-exported functions.

We firstly add the needed JLL package to our dependency using the package mode of the interactive shell. If the targeting JLL package has been submitted to Yggdrasil and is registered, `] add package_jll.jl` would do the job. Otherwise you need to point to the exact github repository it resides with commands like `] add github.com/youwuyou/simpson_jll.jl`.

The artifacts will be fetched and we can find them using the `artifact_dir` variable.

```julia
julia> using simpson_jll

julia> simpson_jll.artifact_dir
"/path/to/.julia/artifacts/89430912394f19fb4ec96a345d5a6ef346eae22"
```

Now make sure you can find header files under `artifact_dir` and then you can create your first Julia wrappers for C libraries from a collection of header files by following this [Clang.jl tutorial](https://juliainterop.github.io/Clang.jl/stable/)! In Simpson.jl, we put relevant scripts into `Clang.jl/res` folder and the autogenerated low-level API that contains Julia wrappers is contained in `src/api.jl` that gets generated.

###4. Implementation of a high-level Julia API

Congratulations! Now you can start with creating high-level wrapper functions by using low-level wrapper functions within `src/api.jl` script, which we do Within `src/Simpson.jl`.