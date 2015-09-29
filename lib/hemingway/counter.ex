defmodule Hemingway.Counter do
  @token_regexp ~r/\s+/u

  @doc """
  Counts the number of tokens in a string.
  """
  def count(string, pattern \\ @token_regexp) do
    length tokens(string, pattern)
  end

  @doc """
  Counts the number of chars in a string.
  """
  def char_count(string) do
    String.length(string)
  end

  @doc """
  Splits a string into a list of tokens using a given regular expression.
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
