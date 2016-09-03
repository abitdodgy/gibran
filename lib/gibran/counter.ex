defmodule Gibran.Counter do
  @moduledoc """
  A set of functions that retrieve statistics on a list of tokens.
  """

  @doc ~S"""
  Given a list of tokens, it returns a unique list.

  ### Examples

      iex> Gibran.Counter.uniq_tokens(["the", "prophet", "eye", "of", "the", "prophet"])
      ["the", "prophet", "eye", "of"]
  """
  def uniq_tokens(list), do: Enum.uniq(list)

  @doc ~S"""
  Returns an integer of the number of tokens in a list.

  ### Examples

      iex> Gibran.Counter.token_count(["the", "madman"])
      2
  """
  def token_count(list), do: length(list)

  @doc ~S"""
  Returns an integer of the number of unique tokens in a list.

  ### Examples

      iex> Gibran.Counter.uniq_token_count(["the", "prophet", "eye", "of", "the", "prophet"])
      4
  """
  def uniq_token_count(list), do: uniq_tokens(list) |> length

  @doc ~S"""
  Returns an integer of the number of characters in a list.

  ### Examples

      iex> Gibran.Counter.char_count(["the", "wanderer"])
      11
  """
  def char_count(list) do
    Enum.reduce list, 0, fn token, acc ->
      String.length(token) + acc
    end
  end

  @doc ~S"""
  Returns a float of the average characters per token.

  ### Examples

      iex> Gibran.Counter.average_chars_per_token(["twenty", "drawings"])
      7.0

      iex> Gibran.Counter.average_chars_per_token(["The", "Treasured", "Writings", "of", "Kahlil", "Gibran"], precision: 4)
      5.6667

  ### Options

  - `:precision` The maximum total number of decimal digits that will be returned. The `precision` must be an integer.
  """
  def average_chars_per_token(list, opts \\ []) do
    precision = Keyword.get(opts, :precision, 2)
    char_count(list) / token_count(list) |> Float.round(precision)
  end

  @doc ~S"""
  Returns an unordered `Map` of tokens and their lengths.

  ### Examples

      iex> Gibran.Counter.token_lengths(["voice", "and", "master"])
      %{"and" => 3, "master" => 6, "voice" => 5}
  """
  @spec token_lengths(list) :: map
  def token_lengths(list) do
    Enum.uniq(list) |> Enum.reduce(Map.new, fn token, map ->
      Map.put map, token, String.length(token)
    end)
  end

  @doc ~S"""
  Returns a `List` of two-element tuples of the longest tokens.
  Each tuple contains the token and its length respectively.

  ### Examples

      iex> Gibran.Counter.longest_tokens(["kingdom", "of", "the", "imagination"])
      [{"imagination", 11}]
  """
  def longest_tokens(list), do: token_lengths(list) |> top_ranked

  @doc ~S"""
  Returns a `Map` of tokens and the number of times they occur.

  ### Examples

      iex> Gibran.Counter.token_frequency(["the", "prophet", "eye", "of", "the", "prophet"])
      %{"eye" => 1, "of" => 1, "prophet" => 2, "the" => 2}
  """
  @spec token_frequency(list) :: map
  def token_frequency(list) do
    Enum.reduce list, Map.new, fn token, map ->
      Map.update map, token, 1, &(&1 + 1)
    end
  end

  @doc ~S"""
  Returns a `List` of two-element tuples with the highest frequency. Each tuple consists of
  the token and its frequency.

  ### Examples

      iex> Gibran.Counter.most_frequent_tokens(["the", "prophet", "eye", "of", "the", "prophet"])
      [{"prophet", 2}, {"the", 2}]
  """
  def most_frequent_tokens(list), do: token_frequency(list) |> top_ranked

  @doc ~s"""
  Returns a `Map` of tokens and their densities as floats.

  ### Examples

      iex> Gibran.Counter.token_density(["the", "prophet", "eye", "of", "the", "prophet"])
      %{"eye" => 0.17, "of" => 0.17, "prophet" => 0.33, "the" => 0.33}

      iex> Gibran.Counter.token_density(["the", "prophet", "eye", "of", "the", "prophet"], 4)
      %{"eye" => 0.1667, "of" => 0.1667, "prophet" => 0.3333, "the" => 0.3333}

  ### Options

  - `:precision` The maximum total number of decimal digits that will be included in desnity. The `precision` must be an integer.
  """
  @spec token_density(list, integer) :: map
  def token_density(list, precision \\ 2) do
    list_size = token_count(list)
    token_frequency(list) |> Enum.reduce(Map.new, fn {token, frequency}, map ->
      Map.put map, token, Float.round(frequency / list_size, precision)
    end)
  end

  defp top_ranked(map) do
    Enum.group_by(map, fn {_, x} -> x end) |> Enum.max |> elem(1)
  end
end
