module CornellMovieDialogsCorpus

export
    movie_conversations, movie_lines,
    movie_title_metadata, movie_character_metadata

using Dates
using CSV, DataDeps

basedir()                 = datadep"CornellMovieDialogsCorpus"

character_metadata_file() = joinpath(basedir(), "movie_characters_metadata.txt")
conversations_file()      = joinpath(basedir(), "movie_conversations.txt")
lines_file()              = joinpath(basedir(), "movie_lines.txt")
title_metadata_file()     = joinpath(basedir(), "movie_titles_metadata.txt")
raw_script_urls_file()    = joinpath(basedir(), "raw_script_urls.txt")
readme_file()             = joinpath(basedir(), "README.txt")

read_list(str) = [m.captures[1] for m in eachmatch(r"'([^']+)'", str)]

function movie_data(file, header; kwargs...)
    kws = kwargs.data
    args = keys(kws)
    NT = tuple(header...)
    tup = tuple([a in args ? kws[a] : identity for a in header]...)
    funcs = NamedTuple{NT}(tup)
    file = CSV.File(file, delim=" +++\$+++ ", header=header, quotechar='\\', escapechar='\\')
    x = CSV.Tables.rows(file)
    CSV.Transforms{typeof(x), typeof(funcs), true}(x, funcs)
end

"""
    movie_conversations(;kwargs...)

"""
function movie_conversations(;kwargs...)
    header = [:character1_id, :character2_id, :movie_id, :lines]
    movie_data(conversations_file(), header; lines=read_list, kwargs...)
end

"""
    movie_lines(;kwargs...)

todo
"""
function movie_lines(;kwargs...)
    header = [:line_id, :character_id, :movie_id, :character_name, :text]
    movie_data(lines_file(), header)
end

"""
    movie_titles_metadata(;kwargs...)

todo
"""
function movie_title_metadata(;kwargs...)
    header = [:movie_id, :title, :year, :rating, :votes, :genres]
    default_kwargs = (year=Date, rating=x -> parse(Float64, x),
                      votes=x -> parse(Int, x), genres=read_list)
    movie_data(title_metadata_file(), header; default_kwargs..., kwargs...) 
end

"""
    movie_character_metadata(;kwargs...)

todo
"""
function movie_character_metadata(;kwargs...)
    header = [:character_id, :name, :movie_id, :title, :gender, :position]
    movie_data(character_metadata_file(), header; )
end

"""
    movie_script_urls(;kwargs...)

todo
"""
function movie_script_urls(;kwargs...)
    header = [:movie_id, :movie_title, :url]
    movie_data(raw_script_urls_file(), header; kwargs...)
end

function _unpack(zip)
    unpack(zip)
    dir = "cornell movie-dialogs corpus"
    for file in readdir(dir)
        if endswith(file, ".pdf") || endswith(file, ".txt")
            cp(joinpath(dir, file), "./$file")
        end
    end
    rm(dir, recursive=true)
    rm("__MACOSX", recursive=true)
end

function __init__()
    url = "http://www.cs.cornell.edu/~cristian/data/cornell_movie_dialogs_corpus.zip"
    sha = "3bde8a571f615201bc2d2453e22878090719638592f774720eddec739de8c900"
    register(DataDep("CornellMovieDialogsCorpus",
                     """
                     """,
                     url, sha, post_fetch_method = _unpack))
end

end # module
