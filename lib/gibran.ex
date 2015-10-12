defmodule Gibran do
  @moduledoc ~S"""
  This module includes shortcut functions that bridge `Gibran.Tokeniser` and `Gibran.Counter`.
  This allows the caller to directly work with strings instead of tokenising the
  input first before applying any calculations.
  """

  import Gibran.Tokeniser

  alias Gibran.Counter

  @doc ~S"""
  Takes a string and an atom that refers to any function name in `Gibran.Counter`.
  It tokenises the string, then applies the given function to the resulting tokens. The function
  name must be an `atom`. You can pass a list of options to the tokeniser as `opts` and a list
  of options to the receiving function as `fn_opts`.

  For example, the following two calls are equivalent:

    Gibran.from_string("The Prophet", :token_count)

    Gibran.Tokeniser.tokenise("The Prophet") |> Gibran.Counter.token_count

  ## Examples

    iex> Gibran.from_string("The Prophet", :token_count)
    2

    iex> Gibran.from_string("The Prophet", :token_count, opts: [exclude: "the"])
    1

    iex> Gibran.from_string("Eye of The Prophet", :average_chars_per_token, fn_opts: [precision: 1])
    3.8

    iex> Gibran.from_string("Eye of The Prophet", :average_chars_per_token,\
      opts: [exclude: "of"],\
      fn_opts: [precision: 4]\
    )
    4.3333

  To view all available functions see `Gibran.Counter` or type the following into iex:

    Gibran.Counter.__info__(:functions)

  See `Gibran.Tokeniser.tokenise/2` and `Gibran.Counter` for more information.
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
