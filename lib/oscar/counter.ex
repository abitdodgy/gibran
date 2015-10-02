defmodule Oscar.Counter do
  @moduledoc """
  A set of functions for analysing strings.
  """

  @token_regexp ~r/[^\p{L}'-]/u

  @doc ~S"""
  Splits a string into a list of tokens using a given regular expression that defaults to `@token_regexp`.

    iex> Oscar.Counter.tokens(\
      "We are all in the gutter, but some of us are looking at the stars."\
    )
    [ "We", "are", "all", "in", "the", "gutter", "but",\
      "some", "of", "us", "are", "looking", "at", "the", "stars" ]

  The default regular expression ignores punctuation, but accounts for apostrophes and compound words.

    iex> Oscar.Counter.tokens(\
      "Good people exasperate one's reason; bad people stir one's imagination."\
    )
    [ "Good", "people", "exasperate", "one's", "reason",\
      "bad", "people", "stir", "one's", "imagination" ]

    iex> Oscar.Counter.tokens(\
      "The man who can dominate a London dinner-table can dominate the world."\
    )
    [ "The", "man", "who", "can", "dominate", "a", "London",\
      "dinner-table", "can", "dominate", "the", "world" ]

  ### Options

  - `:pattern` A regular expression to tokenise the input. It defaults to `@token_regexp`.
  - `:exclude` A filter that can be a function, string, list, or regular expression to apply
  to the input after it has been tokenised. Use `exclude` to exclude tokens from the analysis.

  ### Examples

    iex> Oscar.Counter.tokens(\
      "The man who can dominate a London dinner-table can dominate the world.",\
      pattern: ~r/[^\p{L}]/\
    )
    [ "The", "man", "who", "can", "dominate", "a", "London",\
      "dinner", "table", "can", "dominate", "the", "world" ]

    iex> Oscar.Counter.tokens(\
      "It is only the modern that ever becomes old-fashioned.",\
      exclude: &(String.length(&1) > 3)\
    )
    ["It", "is", "the"]

    iex> Oscar.Counter.tokens(\
      "It is only the modern that ever becomes old-fashioned.", exclude: ~r/old-fashioned/\
    )
    ["It", "is", "only", "the", "modern", "that", "ever", "becomes"]

    iex> Oscar.Counter.tokens(\
      "It is only the modern that ever becomes old-fashioned.",\
      exclude: "It is only that"\
    )
    ["the", "modern", "ever", "becomes", "old-fashioned"]

    iex> Oscar.Counter.tokens(\
      "It is only the modern that ever becomes old-fashioned.",\
      exclude: ["It", "is", "only", "that", "ever"]\
    )
    ["the", "modern", "becomes", "old-fashioned"]
  """
  def tokens(input, opts \\ []) do
    pattern = Keyword.get(opts, :pattern, @token_regexp)
    exclude = Keyword.get(opts, :exclude)

    String.split(input, pattern, trim: true) |> reject(exclude)
  end

  @doc ~S"""
  Returns a list of unique tokens from a string.

  ## Examples

    iex> Oscar.Counter.uniq_tokens(\
      "Good people exasperate one's reason; bad people stir one's imagination."\
    )
    ["Good", "people", "exasperate", "one's", "reason", "bad", "stir", "imagination"]

  ## Options

  - `:pattern` See `Oscar.Counter.tokens/2`.
  - `:exclude` See `Oscar.Counter.tokens/2`.
  """
  def uniq_tokens(input, opts \\ []) do
    tokens(input, opts) |> Enum.uniq
  end

  @doc ~S"""
  Counts the number of tokens in a string.

  ## Examples

    iex> Oscar.Counter.token_count("True friends stab you in the front.")
    7

  ## Options

  - `:pattern` See `Oscar.Counter.tokens/2`.
  - `:exclude` See `Oscar.Counter.tokens/2`.
  """
  def token_count(input, opts \\ []) do
    tokens(input, opts) |> length
  end

  @doc ~S"""
  Counts the number of unique tokens in a string.

  ## Examples

    iex> Oscar.Counter.uniq_token_count(\
      "If you are not too long, I will wait here for you all my life."\
    )
    14

  ## Options

  - `:pattern` See `Oscar.Counter.tokens/2`.
  - `:exclude` See `Oscar.Counter.tokens/2`.
  """
  def uniq_token_count(input, opts \\ []) do
    uniq_tokens(input, opts) |> length
  end

  @doc ~S"""
  Counts the number of characters in a string.

  ## Examples

    iex> Oscar.Counter.char_count(\
      "It is better to have a permanent income than to be fascinating."\
    )
    63
  """
  def char_count(input), do: String.length(input)

  @doc ~S"""
  Returns average characters per token.

  ## Examples

    iex> Oscar.Counter.average_chars_per_token(\
      "If you are not too long, I will wait here for you all my life."\
    )
    3.07

    iex> Oscar.Counter.average_chars_per_token(\
      "If you are not too long, I will wait here for you all my life.",\
      precision: 4\
    )
    3.0667

  ## Options

  - `:precision` The maximum total number of decimal digits that will be returned.
  The `precision` must be an integer.
  - `:pattern` See `Oscar.Counter.tokens/2`.
  - `:exclude` See `Oscar.Counter.tokens/2`.
  """
  def average_chars_per_token(input, opts \\ []) do
    precision = Keyword.get(opts, :precision, 2)
    tokens = tokens(input, opts)

    (tokens
      |> List.to_string
      |> String.length) / length(tokens) |> Float.round(precision)
  end

  @doc ~S"""
  Returns an unordered `HashDict` of tokens and their lengths.

  ## Examples

    iex> Oscar.Counter.token_lengths(\
      "Be yourself; everyone else is already taken."\
    )
    #HashDict<[{"taken", 5}, {"yourself", 8}, {"already", 7}, {"is", 2}, {"Be", 2}, {"else", 4}, {"everyone", 8}]>

  ## Options

  - `:pattern` See `Oscar.Counter.tokens/2`.
  - `:exclude` See `Oscar.Counter.tokens/2`.
  """
  def token_lengths(input, opts \\ []) do
    tokens(input, opts) |> Enum.uniq |> Enum.reduce(HashDict.new, fn (word, dict) ->
      HashDict.put dict, word, String.length(word)
    end)
  end

  @doc ~S"""
  Returns a `List` of two-element tuples of the longest tokens.
  Each tuple contains the token and its length respectively.

  ## Examples

    iex> Oscar.Counter.longest_tokens(\
      "If you are not too long, I will wait here for you all my life."\
    )
    [{"here", 4}, {"will", 4}, {"long", 4}, {"wait", 4}, {"life", 4}]

  ## Options

  - `:pattern` See `Oscar.Counter.tokens/2`.
  - `:exclude` See `Oscar.Counter.tokens/2`.
  """
  def longest_tokens(input, opts \\ []) do
    token_lengths(input, opts) |> top_ranked
  end

  @doc ~S"""
  Returns a `HashDict` of tokens and the number of times they occur.

  ## Examples

  iex> Oscar.Counter.token_frequency("Oscar Oscar Oscar Fingal Fingal Wilde")
  #HashDict<[{"Wilde", 1}, {"Fingal", 2}, {"Oscar", 3}]>

  ## Options

  - `:pattern` See `Oscar.Counter.tokens/2`.
  - `:exclude` See `Oscar.Counter.tokens/2`.
  """
  def token_frequency(input, opts \\ []) do
    tokens(input, opts) |> Enum.reduce(HashDict.new, fn (word, dict) ->
      Dict.update dict, word, 1, &(&1 + 1)
    end)
  end

  @doc ~S"""
  Returns a list tokens with the highest frequency. Each token is a two-element tuple consisteing of
  frequency and the token.

  ## Examples

    iex> Oscar.Counter.most_frequent_tokens(\
      "If you are not too long, I will wait here for you all, all my life."\
    )
    [{"you", 2}, {"all", 2}]

  ## Options

  - `:pattern` See `Oscar.Counter.tokens/2`.
  - `:exclude` See `Oscar.Counter.tokens/2`.
  """
  def most_frequent_tokens(input, opts \\ []) do
    token_frequency(input, opts) |> top_ranked
  end


  defp top_ranked(dict) do
    Enum.group_by(dict, fn {_, x} -> x end) |> Enum.max |> elem(1)
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
