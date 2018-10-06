module CornellMovieDialogsCorpus

using DataDeps

basedir()              = datadep"Cornell Movie Dialogs Corpus"

metadata_file()        = joinpath(basedir(), "movie_characters_metadata.txt")
conversations_file()   = joinpath(basedir(), "movie_conversations.txt")
lines_file()           = joinpath(basedir(), "movie_lines.txt")
titles_metadata_file() = joinpath(basedir(), "movie_titles_metadata.txt")
raw_script_urls_file() = joinpath(basedir(), "raw_script_urls.txt")
readme()               = joinpath(basedir(), "README.txt")


function __init__()
    register(DataDep("Cornell Movie Dialogs Corpus",
                     """
                     """,
                     "http://www.cs.cornell.edu/~cristian/data/cornell_movie_dialogs_corpus.zip",
                     "3bde8a571f615201bc2d2453e22878090719638592f774720eddec739de8c900",
                     post_fetch_method = function (zip)
                         unpack(zip)
                         dir = "cornell movie-dialogs corpus"
                         for file in filter(x -> endswith(x, ".pdf") || endswith(x, ".txt"), readdir(dir))
                             cp(joinpath(dir, file), "./$file")
                         end
                         rm(dir, recursive=true)
                         rm("__MACOSX", recursive=true)
                     end))
end

end # module
