using CornellMovieDialogsCorpus:
    metadata_file, conversations_file, lines_file,
    titles_metadata_file, raw_script_urls_file, readme 
using Test

for filef in [metadata_file, conversations_file, lines_file,
              titles_metadata_file, raw_script_urls_file, readme]
    file = filef()
    @test isfile(file)
end
