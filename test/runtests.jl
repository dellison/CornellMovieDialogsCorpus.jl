using CornellMovieDialogsCorpus, Test

@testset "CornellMovieDialogsCorpus.jl" begin
    characters = movie_character_metadata()
    conversations = movie_conversations()
    lines = movie_lines()
    movies = movie_title_metadata()

    @test isfile(CornellMovieDialogsCorpus.readme_file())

    @test length(characters) == 9035
    @test length(movies) == 617
    @test length(lines) == 304_713

    @test length(lines) == sum(length.([conv.lines for conv in conversations]))
    @test length(movie_script_urls()) == length(movies)
end
