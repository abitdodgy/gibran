defmodule Oscar.Tokeniser do
  @moduledoc ~S"""
  Tokenises a string into a list.
  """

  @token_regexp ~r/[^\p{L}'-]/u

  @doc ~S"""
  Splits a string into a list of tokens with a regular expression. If a regular expression
  is not provided it defaults to `@token_regexp`.

    iex> Oscar.Tokeniser.tokenise("The Prophet")
    ["The", "Prophet"]

  The default regular expression ignores punctuation, but accounts for apostrophes
  and compound words.

    iex> Oscar.Tokeniser.tokenise("Prophet, The")
    ["Prophet", "The"]

    iex> Oscar.Tokeniser.tokenise("Al-Ajniha al-Mutakassira")
    ["Al-Ajniha", "al-Mutakassira"]

  ### Options

  - `:pattern` A regular expression to tokenise the input. It defaults to `@token_regexp`.
  - `:exclude` A filter that can be a function, string, list, or regular expression to apply
  to the input after it has been tokenised.
  Use `exclude` to exclude tokens from the final list.

  ### Examples

    iex> Oscar.Tokeniser.tokenise("Broken Wings, 1912", pattern: ~r/\,/)
    ["Broken Wings", " 1912"]

    iex> Oscar.Tokeniser.tokenise("Kingdom of the Imagination", exclude: &(String.length(&1) < 10))
    ["Imagination"]

    iex> Oscar.Tokeniser.tokenise("Sand and Foam", exclude: ~r/and/)
    ["Foam"]

    iex> Oscar.Tokeniser.tokenise("Eye of The Prophet", exclude: "Eye of")
    ["The", "Prophet"]

    iex> Oscar.Tokeniser.tokenise("Eye of The Prophet", exclude: ["Eye", "of"])
    ["The", "Prophet"]
  """
  def tokenise(input, opts \\ []) do
    pattern = Keyword.get(opts, :pattern, @token_regexp)
    exclude = Keyword.get(opts, :exclude)

    String.split(input, pattern, trim: true) |> reject(exclude)
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
