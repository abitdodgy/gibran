defmodule Oscar.Tokeniser do
  @moduledoc ~S"""
  Tokenises a string into a list.
  """

  @token_regexp ~r/[^\p{L}'-]/u

  @doc ~S"""
  Splits a string into a list of tokens with a regular expression. If a regular is not provided
  it defaults to `@token_regexp`.

    iex> Oscar.Tokeniser.tokenise("We are all in the gutter, but some of us are looking at the stars.")
    [ "We", "are", "all", "in", "the", "gutter", "but",\
      "some", "of", "us", "are", "looking", "at", "the", "stars" ]

  The default regular expression ignores punctuation, but accounts for apostrophes and compound words.

    iex> Oscar.Tokeniser.tokenise("Good people exasperate one's reason; bad people stir one's imagination.")
    [ "Good", "people", "exasperate", "one's", "reason",\
      "bad", "people", "stir", "one's", "imagination" ]

    iex> Oscar.Tokeniser.tokenise("The man who can dominate a London dinner-table can dominate the world.")
    [ "The", "man", "who", "can", "dominate", "a", "London",\
      "dinner-table", "can", "dominate", "the", "world" ]

  ### Options

  - `:pattern` A regular expression to tokenise the input. It defaults to `@token_regexp`.
  - `:exclude` A filter that can be a function, string, list, or regular expression to apply
  to the input after it has been tokenised. Use `exclude` to exclude tokens from the final list.

  ### Examples

    iex> Oscar.Tokeniser.tokenise(\
      "The man who can dominate a London dinner-table can dominate the world.",\
      pattern: ~r/[^\p{L}]/\
    )
    [ "The", "man", "who", "can", "dominate", "a", "London",\
      "dinner", "table", "can", "dominate", "the", "world" ]

    iex> Oscar.Tokeniser.tokenise(\
      "It is only the modern that ever becomes old-fashioned.",\
      exclude: &(String.length(&1) > 3)\
    )
    ["It", "is", "the"]

    iex> Oscar.Tokeniser.tokenise(\
      "It is only the modern that ever becomes old-fashioned.",\
      exclude: ~r/old-fashioned/\
    )
    ["It", "is", "only", "the", "modern", "that", "ever", "becomes"]

    iex> Oscar.Tokeniser.tokenise(\
      "It is only the modern that ever becomes old-fashioned.",\
      exclude: "It is only that"\
    )
    ["the", "modern", "ever", "becomes", "old-fashioned"]

    iex> Oscar.Tokeniser.tokenise(\
      "It is only the modern that ever becomes old-fashioned.",\
      exclude: ["It", "is", "only", "that", "ever"]\
    )
    ["the", "modern", "becomes", "old-fashioned"]
  """
  def tokenise(input, opts \\ []) do
    pattern = Keyword.get(opts, :pattern, @token_regexp)
    exclude = Keyword.get(opts, :exclude)

    String.split(input, pattern, trim: true) |> reject(exclude)
  end

  defp reject(list, filter) do
    cond do
      is_function(filter) ->
        Enum.reject(list, filter)
      Regex.regex?(filter) ->
        Enum.reject list, &Regex.match?(filter, &1)
      is_list(filter) ->
        Enum.reject list, &Enum.member?(filter, &1)
      is_binary(filter) ->
        reject list, String.split(filter, " ", trim: true)
      true ->
        list
    end
  end
end
