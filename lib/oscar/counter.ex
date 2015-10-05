defmodule Oscar.Counter do
  @moduledoc """
  A set of functions for analysing lists of tokens.
  """

  @doc ~S"""
  Given a list of tokens, returns a unique list.

  ## Examples

    iex> Oscar.Counter.uniq_tokens(\
      "Good people exasperate one's reason; bad people stir one's imagination."\
    )
    ["Good", "people", "exasperate", "one's", "reason", "bad", "stir", "imagination"]
  """
  def uniq_tokens(list), do: Enum.uniq(list)

  @doc ~S"""
  Counts the number of tokens in a list.

  ## Examples

    iex> Oscar.Counter.token_count("True friends stab you in the front.")
    7
  """
  def token_count(list), do: length(list)

  @doc ~S"""
  Counts the number of unique tokens in a list.

  ## Examples

    iex> Oscar.Counter.uniq_token_count(\
      "If you are not too long, I will wait here for you all my life."\
    )
    14
  """
  def uniq_token_count(list) do
    list |> uniq_tokens |> length
  end

  @doc ~S"""
  Counts the number of characters in a list.

  ## Examples

    iex> Oscar.Counter.char_count(\
      "It is better to have a permanent income than to be fascinating."\
    )
    63
  """
  def char_count(list), do: Enum.reduce(list, &String.length(&1))

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
  """
  def average_chars_per_token(list, opts \\ []) do
    precision = Keyword.get(opts, :precision, 2)
    char_count(list) / token_count(list) |> Float.round(precision)
  end

  @doc ~S"""
  Returns an unordered `HashDict` of tokens and their lengths.

  ## Examples

    iex> Oscar.Counter.token_lengths(\
      "Be yourself; everyone else is already taken."\
    )
    #HashDict<[{"taken", 5}, {"yourself", 8}, {"already", 7}, {"is", 2}, {"Be", 2}, {"else", 4}, {"everyone", 8}]>
  """
  def token_lengths(list) do
    list |> Enum.uniq |> Enum.reduce(HashDict.new, fn (token, dict) ->
      HashDict.put dict, token, String.length(token)
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
  """
  def longest_tokens(list) do
    list |> token_lengths |> top_ranked
  end

  @doc ~S"""
  Returns a `HashDict` of tokens and the number of times they occur.

  ## Examples

  iex> Oscar.Counter.token_frequency("Oscar Oscar Oscar Fingal Fingal Wilde")
  #HashDict<[{"Wilde", 1}, {"Fingal", 2}, {"Oscar", 3}]>
  """
  def token_frequency(list) do
    list |> Enum.reduce(HashDict.new, fn (token, dict) ->
      Dict.update dict, token, 1, &(&1 + 1)
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
  """
  def most_frequent_tokens(list) do
    list |> token_frequency |> top_ranked
  end

  defp top_ranked(dict) do
    Enum.group_by(dict, fn {_, x} -> x end) |> Enum.max |> elem(1)
  end
end
