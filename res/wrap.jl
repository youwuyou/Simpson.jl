using Clang.Generators
import simpson_jll

include_dir = normpath(simpson_jll.artifact_dir, "include")
isdir(include_dir) || error("$header_dir does not exist")

# wrapper generator options
options = load_options(joinpath(@__DIR__, "wrap.toml"))

# add compiler flags, e.g. "-DXXXXXXXXX"
args = get_default_args()
push!(args, "-I$include_dir")
push!(args, "-DBUILD_SHARED_LIBS")

# specifying C API header to parse
headers = [joinpath(include_dir, header) for header in readdir(include_dir) if endswith(header, ".h")]

# there is also an experimental `detect_headers` function for auto-detecting top-level headers in the directory
# headers = detect_headers(clang_dir, args)

# create context
ctx = create_context(headers, args, options)

# run generator
build!(ctx)