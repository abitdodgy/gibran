defmodule Oscar.Counter do
  @moduledoc """
  A set of functions for analysing strings.
  """

  @token_regexp ~r/[^\p{L}'-]/u

  @doc ~S"""
  Splits a string into a list of tokens using a given regular expression that defaults to `@token_regexp`.

  ## Examples

      iex> Oscar.Counter.tokens("We are all in the gutter, but some of us are looking at the stars.")
      ["We", "are", "all", "in", "the", "gutter", "but", "some", "of", "us", "are", "looking", "at", "the", "stars"]

  It ignores punctuation, but accounts for apostrophes and compound words.

      iex> Oscar.Counter.tokens("Good people exasperate one's reason; bad people stir one's imagination.")
      ["Good", "people", "exasperate", "one's", "reason", "bad", "people", "stir", "one's", "imagination"]

      iex> Oscar.Counter.tokens("The man who can dominate a London dinner-table can dominate the world.")
      ["The", "man", "who", "can", "dominate", "a", "London", "dinner-table", "can", "dominate", "the", "world"]

  It accepts a `:pattern` regular expression option used to tokenise the string.

      iex> Oscar.Counter.tokens("The man who can dominate a London dinner-table can dominate the world.", pattern: ~r/[^\p{L}]/)
      ["The", "man", "who", "can", "dominate", "a", "London", "dinner", "table", "can", "dominate", "the", "world"]

  It accepts an `:exclude` option. `:exclude` can be a function, a list, a string, or a regular expression. The expression
  is applied to the string after its tokenised.

      iex> Oscar.Counter.tokens("It is only the modern that ever becomes old-fashioned.", exclude: &(String.length(&1) > 3))
      ["It", "is", "the"]

      iex> Oscar.Counter.tokens("It is only the modern that ever becomes old-fashioned.", exclude: ~r/old-fashioned/)
      ["It", "is", "only", "the", "modern", "that", "ever", "becomes"]

      iex> Oscar.Counter.tokens("It is only the modern that ever becomes old-fashioned.", exclude: "It is only that")
      ["the", "modern", "ever", "becomes", "old-fashioned"]

      iex> Oscar.Counter.tokens("It is only the modern that ever becomes old-fashioned.", exclude: ["It", "is", "only", "that", "ever"])
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

      iex> Oscar.Counter.unique_tokens("Good people exasperate one's reason; bad people stir one's imagination.")
      ["Good", "people", "exasperate", "one's", "reason", "bad", "stir", "imagination"]

  It accepts `:pattern` and `:exclude` options, and uses `@token_regexp` to tokenize the string unless one is provided.
  See `Oscar.Counter.tokens/2`.
  """
  def unique_tokens(string, opts \\ []) do
    tokens(string, opts) |> Enum.uniq
  end

  @doc ~S"""
  Counts the number of tokens in a string.

  ## Examples

      iex> Oscar.Counter.token_count("True friends stab you in the front.")
      7

  It accepts `:pattern` and `:exclude` options, and uses `@token_regexp` to tokenize the string unless one is provided.
  See `Oscar.Counter.tokens/2`.
  """
  def token_count(input, opts \\ []) do
    tokens(input, opts) |> length
  end

  @doc ~S"""
  Counts the number of unique tokens in a string.

  ## Examples

      iex> Oscar.Counter.uniq_token_count("If you are not too long, I will wait here for you all my life.")
      14

  It accepts `:pattern` and `:exclude` options, and uses `@token_regexp` to tokenize the string unless one is provided.
  See `Oscar.Counter.tokens/2`.
  """
  def uniq_token_count(input, opts \\ []) do
    unique_tokens(input, opts) |> length
  end

  @doc ~S"""
  Counts the number of characters in a string.

  ## Examples

      iex> Oscar.Counter.char_count("It is better to have a permanent income than to be fascinating.")
      63
  """
  def char_count(input), do: String.length(input)

  @doc ~S"""
  Returns average characters per token.

  ## Examples

      iex> Oscar.Counter.average_chars_per_token("If you are not too long, I will wait here for you all my life.")
      3.07

  It accepts a `:precision` option.

      iex> Oscar.Counter.average_chars_per_token("If you are not too long, I will wait here for you all my life.", precision: 4)
      3.0667

  It accepts `:pattern` and `:exclude` options, and uses `@token_regexp` to tokenize the string unless one is provided.
  See `Oscar.Counter.tokens/2`.
  """
  def average_chars_per_token(input, opts \\ []) do
    precision = Keyword.get(opts, :precision, 2)
    tokens = tokens(input, opts)

    (tokens
      |> List.to_string
      |> String.length) / length(tokens) |> Float.round(precision)
  end

  @doc ~S"""
  Returns a two-element tuple of the length, and a list of the longest tokens.

  ## Examples

      iex> Oscar.Counter.longest_tokens("If you are not too long, I will wait here for you all my life.")
      {4, ["life", "here", "wait", "will", "long"]}

  It accepts `:pattern` and `:exclude` options, and uses `@token_regexp` to tokenize the string unless one is provided.
  See `Oscar.Counter.tokens/2`.
  """
  def longest_tokens(input, opts \\ []) do
    tokens(input, opts) |> Enum.group_by(&String.length(&1)) |> Enum.max
  end

  @doc """
  Applies a filter to the input after it is tokenised.
  """
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
