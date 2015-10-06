defmodule Oscar.Counter do
  @moduledoc """
  A set of functions for analysing lists of tokens.
  """

  @doc ~S"""
  Given a list of tokens, it returns a unique list.

  ## Examples

    iex> Oscar.Counter.uniq_tokens(["the", "prophet", "eye", "of", "the", "prophet"])
    ["the", "prophet", "eye", "of"]
  """
  def uniq_tokens(list), do: Enum.uniq(list)

  @doc ~S"""
  Counts the number of tokens in a list.

  ## Examples

    iex> Oscar.Counter.token_count(["the", "madman"])
    2
  """
  def token_count(list), do: length(list)

  @doc ~S"""
  Counts the number of unique tokens in a list.

  ## Examples

    iex> Oscar.Counter.uniq_token_count(["the", "prophet", "eye", "of", "the", "prophet"])
    4
  """
  def uniq_token_count(list), do: list |> uniq_tokens |> length

  @doc ~S"""
  Counts the number of characters in a list.

  ## Examples

    iex> Oscar.Counter.char_count(["the", "wanderer"])
    11
  """
  def char_count(list) do
    Enum.reduce list, 0, fn (token, acc) ->
      String.length(token) + acc
    end
  end

  @doc ~S"""
  Returns a float of the average characters per token.

  ## Examples

    iex> Oscar.Counter.average_chars_per_token(["twenty", "drawings"])
    7.0

    iex> Oscar.Counter.average_chars_per_token(\
      ["The", "Treasured", "Writings", "of", "Kahlil", "Gibran"], precision: 4)
    5.6667

  ## Options

  - `:precision` The maximum total number of decimal digits that will be returned.
  The `precision` must be an integer.
  """
  def average_chars_per_token(list, opts \\ []) do
    precision = Keyword.get(opts, :precision, 2)
    char_count(list) / token_count(list) |> Float.round(precision)
  end

  @doc ~S"""
  Returns an unordered `HashDict` of tokens and their lengths.

  ## Examples

    iex> Oscar.Counter.token_lengths(["voice", "and", "master"])
    #HashDict<[{"and", 3}, {"master", 6}, {"voice", 5}]>
  """
  def token_lengths(list) do
    list |> Enum.uniq |> Enum.reduce HashDict.new, fn (token, dict) ->
      HashDict.put dict, token, String.length(token)
    end
  end

  @doc ~S"""
  Returns a `List` of two-element tuples of the longest tokens.
  Each tuple contains the token and its length respectively.

  ## Examples

    iex> Oscar.Counter.longest_tokens(["kingdom", "of", "the", "imagination"])
    [{"imagination", 11}]
  """
  def longest_tokens(list), do: list |> token_lengths |> top_ranked

  @doc ~S"""
  Returns a `HashDict` of tokens and the number of times they occur.

  ## Examples

    iex> Oscar.Counter.token_frequency(["the", "prophet", "eye", "of", "the", "prophet"])
    #HashDict<[{"the", 2}, {"eye", 1}, {"of", 1}, {"prophet", 2}]>
  """
  def token_frequency(list) do
    list |> Enum.reduce HashDict.new, fn (token, dict) ->
      Dict.update dict, token, 1, &(&1 + 1)
    end
  end

  @doc ~S"""
  Returns a `List` of two-element tuples with the highest frequency. Each tuple consists of
  the token and its frequency.

  ## Examples

    iex> Oscar.Counter.most_frequent_tokens(["the", "prophet", "eye", "of", "the", "prophet"])
    [{"prophet", 2}, {"the", 2}]
  """
  def most_frequent_tokens(list), do: list |> token_frequency |> top_ranked


  defp top_ranked(dict) do
    Enum.group_by(dict, fn {_, x} -> x end) |> Enum.max |> elem(1)
  end
end
