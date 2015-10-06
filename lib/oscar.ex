defmodule Oscar do
  @moduledoc ~S"""
  Includes shortcut functions that bridge `Oscar.Tokeniser` and `Oscar.Counter`.
  This allows the caller to directly work with strings instead of tokenising the
  input first.
  """

  import Oscar.Tokeniser

  alias Oscar.Counter

  @doc ~S"""
  Takes a string and any function name in `Oscar.Counter`. It tokenises the string, then applies
  the function to the resulting tokens. The function name must be an `atom`. You can pass a list of
  options to the tokeniser as `opts` and a list of options to the receiving function as `fn_opts`.

  This is meant as a convenience method, and is equivalent to:

    Oscar.Tokeniser.tokenise("The Prophet")
    |> Oscar.Counter.function_name

  ## Examples

    iex> Oscar.from_string("The Prophet", :token_count)
    2

    iex> Oscar.from_string("The Prophet", :token_count, opts: [exclude: "The"])
    1

    iex> Oscar.from_string("Eye of The Prophet", :average_chars_per_token, fn_opts: [precision: 1])
    3.8

    iex> Oscar.from_string("Eye of The Prophet", :average_chars_per_token, opts: [exclude: "of"], fn_opts: [precision: 4])
    4.3333

  To view all available functions see `Oscar.Counter` or type the following into iex:

    Oscar.Counter.__info__(:functions)

  See `Oscar.Tokeniser.tokenise/2` and `Oscar.Counter` for more information.
  """
  def from_string(input, func) do
  	Kernel.apply(Counter, func, [tokenise(input)])
  end

  def from_string(input, func, opts: opts) do
  	Kernel.apply(Counter, func, [tokenise(input, opts)])
  end

  def from_string(input, func, fn_opts: fn_opts) do
  	Kernel.apply(Counter, func, [tokenise(input), fn_opts])
  end

  def from_string(input, func, opts: opts, fn_opts: fn_opts) do
  	Kernel.apply(Counter, func, [tokenise(input, opts), fn_opts])
  end
end
