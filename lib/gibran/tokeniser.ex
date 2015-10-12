defmodule Gibran.Tokeniser do
  @moduledoc ~S"""
  This module containts functions that allow the caller to convert a string into a list
  of tokens using different strategies.
  """

  @token_regexp ~r/[^\p{L}'-]/u

  @doc ~S"""
  Takes a string and splits it into a list of tokens using a regular expression. If a regular expression
  is not provided it defaults to `@token_regexp`.

    iex> Gibran.Tokeniser.tokenise("The Prophet")
    ["the", "prophet"]

  The default regular expression ignores punctuation, but accounts for apostrophes
  and compound words.

    iex> Gibran.Tokeniser.tokenise("Prophet, The")
    ["prophet", "the"]

    iex> Gibran.Tokeniser.tokenise("Al-Ajniha al-Mutakassira")
    ["al-ajniha", "al-mutakassira"]

  The tokeniser will normalize any input by downcasing all tokens.

    iex> Gibran.Tokeniser.tokenise("THE PROPHET")
    ["the", "prophet"]

  ### Options

  - `:pattern` A regular expression to tokenise the input. It defaults to `@token_regexp`.
  - `:exclude` A filter that is applied to the string after it has been tokenised. It can be
  a function, string, list, or regular expression. This is useful to exclude tokens from the final list.

  ### Examples

    iex> Gibran.Tokeniser.tokenise("Broken Wings, 1912", pattern: ~r/\,/)
    ["broken wings", " 1912"]

    iex> Gibran.Tokeniser.tokenise("Kingdom of the Imagination", exclude: &(String.length(&1) < 10))
    ["imagination"]

    iex> Gibran.Tokeniser.tokenise("Sand and Foam", exclude: ~r/and/)
    ["foam"]

    iex> Gibran.Tokeniser.tokenise("Eye of The Prophet", exclude: "eye of")
    ["the", "prophet"]

    iex> Gibran.Tokeniser.tokenise("Eye of The Prophet", exclude: ["eye", "of"])
    ["the", "prophet"]
  """
  def tokenise(input, opts \\ []) do
    pattern = Keyword.get(opts, :pattern, @token_regexp)
    exclude = Keyword.get(opts, :exclude)

    String.split(input, pattern, trim: true) |> normalise |> reject(exclude)
  end

  def normalise(list) do
    Enum.map list, &String.downcase(&1)
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
