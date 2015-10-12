Gibran
=========

> Yesterday is but today's memory, and tomorrow is today's dream.

[Gibran][2] is an Elixir port of [WordsCounted][1], a Ruby natural language processor. It allows you to extract statistics from a string, such as:

- Token count, unique token count, and character count.
- Average characters per token.
- `HashDict`s of tokens and their frequency and tokens and their lengths.
- The longest token(s) and its length.
- The most frquent token(s) and its frquency.

By default Gibran uses the following regular expression to tokenise strings: `~r/[^\p{L}'-]/u`. However, you can provide your own regular expression through the `pattern` option. You can also combine `pattern` with `exclude` to create some sophisticated tokenisation strategies. The `exclude` option accepts a string, list, function, or a regular expression.

```elixir
alias Gibran.Tokeniser
alias Gibran.Counter

string = "Yesterday is but today's memory, and tomorrow is today's dream."

Tokeniser.tokenise(string, exclude: &String.length(&1) < 4) |> Counter.token_count
# 6
```

Gibran ships with a shortcut method that lets you work directly with strings instead of running them through the tokeniser first.

```elixir
Gibran.from_string(
  "Yesterday is but today's memory, and tomorrow is today's dream.",
  :token_count,
  opts: [exclude: &String.length(&1) < 4]
)
# 6
```

The `doctests` contain extensive examples, so take a look there for more detailed information.

  [1]: https://github.com/abitdodgy/words_counted
  [2]: https://en.wikipedia.org/wiki/Kahlil_Gibran
