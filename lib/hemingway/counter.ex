defmodule Hemingway.Counter do
  @token_regexp ~r/[^\p{L}'-]/u # Missing dash and apostrophe

  @doc ~S"""
  Counts the number of tokens in a string.

  ## Examples

      iex> Hemingway.Counter.count("True friends stab you in the front.")
      7

      iex> Hemingway.Counter.count("If you are not too long, I will wait here for you all my life.")
      15

  Tokens with apostrophes are considered a single word.

      iex> Hemingway.Counter.count("Experience is one thing you can't get for nothing.")
      9

  So are compound words.

      iex> Hemingway.Counter.count("It is only the modern that ever becomes old-fashioned.")
      9
  """
  def count(string, pattern \\ @token_regexp) do
    length tokens(string, pattern)
  end

  @doc ~S"""
  Counts the number of characters in a string.

  ## Examples

      iex> Hemingway.Counter.char_count("It is better to have a permanent income than to be fascinating.")
      63

  """
  def char_count(string) do
    String.length(string)
  end

  @doc ~S"""
  Splits a string into a list of tokens using a given regular expression.

  ## Examples

      iex> Hemingway.Counter.tokens("We are all in the gutter, but some of us are looking at the stars.")
      ["We", "are", "all", "in", "the", "gutter", "but", "some", "of", "us", "are", "looking", "at", "the", "stars"]

  """
  def tokens(string, pattern \\ @token_regexp) do
    String.split(string, pattern, trim: true)
  end

  @doc """
  Returns a list of unique tokens from a string given a regular expression.
  """
  def unique_tokens(string, pattern \\ @token_regexp) do
    Enum.uniq tokens(string, pattern)
  end

  @doc """
  Counts the number of unique tokens in a string.
  """
  def unique_token_count(string, pattern \\ @token_regexp) do
    length unique_tokens(string, pattern)
  end
end
