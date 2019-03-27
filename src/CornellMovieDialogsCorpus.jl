module CornellMovieDialogsCorpus

export
    movie_conversations, movie_lines,
    movie_title_metadata, movie_character_metadata,
    movie_script_urls

using Dates
using CSV, DataDeps

corpusfile(file) = joinpath(datadep"CornellMovieDialogsCorpus", file)

character_metadata_file() = corpusfile("movie_characters_metadata.txt")
conversations_file()      = corpusfile("movie_conversations.txt")
lines_file()              = corpusfile("movie_lines.txt")
title_metadata_file()     = corpusfile("movie_titles_metadata.txt")
raw_script_urls_file()    = corpusfile("raw_script_urls.txt")
readme_file()             = corpusfile("README.txt")

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

Load the conversations file of the movie dialog corpus.

Fields:
1. :character1_id
2. :character2_id
3. :movie_id
4. :lines
"""
function movie_conversations(;kwargs...)
    header = [:character1_id, :character2_id, :movie_id, :lines]
    movie_data(conversations_file(), header; lines=read_list, kwargs...)
end

"""
    movie_lines(;kwargs...)

Load the lines file of the movie dialog corpus.
Fields:
1. :line_id
2. :character_id
3. :movie_id
4. :character_name
5. :text
"""
function movie_lines(;kwargs...)
    header = [:line_id, :character_id, :movie_id, :character_name, :text]
    movie_data(lines_file(), header)
end

"""
    movie_titles_metadata(;kwargs...)

Load the movie title metadata file of the movie dialog corpus.

Fields:
1. :movie_id
2. :title
3. :year
4. :rating
5. :votes
6. :genres
"""
function movie_title_metadata(;kwargs...)
    header = [:movie_id, :title, :year, :rating, :votes, :genres]
    default_kwargs = (year=Date, rating=x -> parse(Float64, x),
                      votes=x -> parse(Int, x), genres=read_list)
    movie_data(title_metadata_file(), header; default_kwargs..., kwargs...) 
end

"""
    movie_character_metadata(;kwargs...)

Load the character metadata file of the movie dialog corpus.

Fields:
1. :character_id
2. :name
3. :movie_id
4. :title
5. :gender
6. :position
"""
function movie_character_metadata(;kwargs...)
    header = [:character_id, :name, :movie_id, :title, :gender, :position]
    movie_data(character_metadata_file(), header; )
end

"""
    movie_script_urls(;kwargs...)

Load the urls file of the movie dialog corpus.

Fields:
1. :movie_id
2. :movie_title
3. :url
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
                     The Cornell Movie-Dialogs Corpus

                     https://www.cs.cornell.edu/~cristian/Cornell_Movie-Dialogs_Corpus.html

                     This corpus contains a large metadata-rich collection of fictional conversations extracted from raw movie scripts:
                     - 220,579 conversational exchanges between 10,292 pairs of movie characters
                     - involves 9,035 characters from 617 movies
                     - in total 304,713 utterances
                     - movie metadata included:
                         - genres
                         - release year
                         - IMDB rating
                         - number of IMDB votes
                         - IMDB rating
                     - character metadata included:
                         - gender (for 3,774 characters)
                         - position on movie credits (3,321 characters)
                     - see README.txt (included) for details
                     """,
                     url, sha, post_fetch_method = _unpack))
end

end # module
