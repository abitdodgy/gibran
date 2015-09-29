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
end
