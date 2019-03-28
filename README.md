# CornellMovieDialogsCorpus.jl

[![Build Status](https://travis-ci.org/dellison/CornellMovieDialogsCorpus.jl.svg?branch=master)](https://travis-ci.org/dellison/CornellMovieDialogsCorpus.jl) [![codecov](https://codecov.io/gh/dellison/CornellMovieDialogsCorpus.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/dellison/CornellMovieDialogsCorpus.jl)

CornellMovieDialogsCorpus.jl is a Julia package that provides a thin wrapper for the [Cornell Movie Dialogs Corpus](https://www.cs.cornell.edu/~cristian/Cornell_Movie-Dialogs_Corpus.html).

## Usage

Exported functions:

* `movie_conversations`
* `movie_lines`
* `movie_title_metadata`
* `movie_character_metadata`
* `movie_script_urls`

Each of these loads the corresponding corpus database file.

## Example

Let's say you want to train a simple chatbot using "call-and-response" dialog pairs as training data, as in [this pytorch tutorial](https://pytorch.org/tutorials/beginner/chatbot_tutorial.html).

```julia
using CornellMovieDialogsCorpus
```

First, create a `Dict` that maps line IDs to the raw text.

```julia
id2text = Dict(l.line_id => l.text for l in movie_lines())
```

Now, create a dataset of (utterance, response) pairs from the movie conversations.

```julia
utterance_pairs = [(id2text[id], id2text[conv.lines[i+1]])
                   for conv in movie_conversations()
                   for (i, id) in enumerate(conv.lines[1:end-1])]
```

```julia
julia> utterance_pairs[1:5]
5-element Array{Tuple{Any,Any},1}:
 ("Can we make this quick?  Roxanne Korrine and Andrew Barrett are having an incredibly horrendous public break- up on the quad.  Again.", "Well, I thought we'd start with pronunciation, if that's okay with you.")
 ("Well, I thought we'd start with pronunciation, if that's okay with you.", "Not the hacking and gagging and spitting part.  Please.")
 ("Not the hacking and gagging and spitting part.  Please.", "Okay... then how 'bout we try out some French cuisine.  Saturday?  Night?")
 ("You're asking me out.  That's so cute. What's your name again?", "Forget it.")
 ("No, no, it's my fault -- we didn't have a proper introduction ---", "Cameron.")
```
