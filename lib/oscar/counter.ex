defmodule Oscar.Counter do
  @token_regexp ~r/[^\p{L}'-]/u

  @doc ~S"""
  Counts the number of tokens in a string.

  ## Examples

      iex> Oscar.Counter.count("True friends stab you in the front.")
      7

      iex> Oscar.Counter.count("If you are not too long, I will wait here for you all my life.")
      15

  Tokens with apostrophes are considered a single word.

      iex> Oscar.Counter.count("Experience is one thing you can't get for nothing.")
      9

  So are compound words.

      iex> Oscar.Counter.count("It is only the modern that ever becomes old-fashioned.")
      9

  It accepts a custom regular expression.

      iex> Oscar.Counter.count("It is only the modern that ever becomes old-fashioned.", ~r/[^\p{L}]/)
      10
  """
  def count(string, pattern \\ @token_regexp) do
    length tokens(string, pattern)
  end

  @doc ~S"""
  Counts the number of characters in a string.

  ## Examples

      iex> Oscar.Counter.char_count("It is better to have a permanent income than to be fascinating.")
      63
  """
  def char_count(string) do
    String.length(string)
  end

  @doc ~S"""
  Splits a string into a list of tokens using a given regular expression.

  ## Examples

      iex> Oscar.Counter.tokens("We are all in the gutter, but some of us are looking at the stars.")
      ["We", "are", "all", "in", "the", "gutter", "but", "some", "of", "us", "are", "looking", "at", "the", "stars"]

  It ignores punctuation, but accounts for apostrophes and compound words.

      iex> Oscar.Counter.tokens("Good people exasperate one's reason; bad people stir one's imagination.")
      ["Good", "people", "exasperate", "one's", "reason", "bad", "people", "stir", "one's", "imagination"]

      iex> Oscar.Counter.tokens("The man who can dominate a London dinner-table can dominate the world.")
      ["The", "man", "who", "can", "dominate", "a", "London", "dinner-table", "can", "dominate", "the", "world"]

  It accepts a regular expression.

      iex> Oscar.Counter.tokens("The man who can dominate a London dinner-table can dominate the world.", ~r/[^\p{L}]/)
      ["The", "man", "who", "can", "dominate", "a", "London", "dinner", "table", "can", "dominate", "the", "world"]
  """
  def tokens(string, pattern \\ @token_regexp) do
    String.split(string, pattern, trim: true)
  end

  @doc ~S"""
  Returns a list of unique tokens from a string given a regular expression.

  ## Examples

      iex> Oscar.Counter.unique_tokens("Good people exasperate one's reason; bad people stir one's imagination.")
      ["Good", "people", "exasperate", "one's", "reason", "bad", "stir", "imagination"]

  It accepts a regular expression.

      iex> Oscar.Counter.unique_tokens("Good people exasperate one's reason; bad people stir one's imagination.", ~r/[^\p{L}]/)
      ["Good", "people", "exasperate", "one", "s", "reason", "bad", "stir", "imagination"]
  """
  def unique_tokens(string, pattern \\ @token_regexp) do
    Enum.uniq tokens(string, pattern)
  end

  @doc ~S"""
  Counts the number of unique tokens in a string given a regular expression.

  ## Examples

      iex> Oscar.Counter.unique_token_count("Good people exasperate one's reason; bad people stir one's imagination.")
      8

  It accepts a regular expression.

      iex> Oscar.Counter.unique_token_count("Good people exasperate one's reason; bad people stir one's imagination.", ~r/[^\p{L}]/)
      ["Good", "people", "exasperate", "one", "s", "reason", "bad", "stir", "imagination"]
      9
  """
  def unique_token_count(string, pattern \\ @token_regexp) do
    length unique_tokens(string, pattern)
  end
end
