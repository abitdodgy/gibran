Gibran
=========

> Yesterday is but today's memory, and tomorrow is today's dream.

![Gibran](http://d.gr-assets.com/authors/1353732571p5/6466154.jpg)

[Gibran][2] is an Elixir port of [WordsCounted][1], a Ruby natural language processor. I have lofty goals for Gibran, such as:

- Metaphone phonetic coding system
- Levenshtein distance algorithm
- Soundex algorithm
- Porter Stemming algorithm
- String similarity as [described by Simon White](http://www.catalysoft.com/articles/StrikeAMatch.html)

But for now, you'll have to be content with a powerful tokeniser and a utility counter.

- Token count, unique token count, and character count.
- Average characters per token.
- `HashDict`s of tokens and their frequencies, lengths, and densities.
- The longest token(s) and its length.
- The most frequent token(s) and its frequency.
- Unique tokens.

## Usage

Let's start with something simple.

```elixir
alias Gibran.Tokeniser
alias Gibran.Counter

str = "Yesterday is but today's memory, and tomorrow is today's dream."
Tokeniser.tokenise(str)
# => ["yesterday", "is", "but", "today's", "memory", "and", "tomorrow", "is", "today's", "dream"]

Tokeniser.tokenise(str) |> Counter.uniq_token_count
# => 8
```

By default Gibran uses the following regular expression to tokenise strings: `~r/[^\p{L}'-]/u`. However, you can provide your own regular expression through the `pattern` option. You can also combine `pattern` with `exclude` to create sophisticated tokenisation strategies. The `exclude` option accepts a string, list, function, or a regular expression.

```elixir
Tokeniser.tokenise(string, exclude: &String.length(&1) < 4) |> Counter.token_count
# => 6
```

Gibran has a shortcut to work with strings directly instead of running them through the tokeniser first.

```elixir
Gibran.from_string(str, :token_count, opts: [exclude: &String.length(&1) < 4])
# => 6
```

Gibran normalises input before applying transformations to avoid inconsistencies that can arise from character-casing.

The `doctests` contain extensive usage examples. Please take a look there for more details.

  [1]: https://github.com/abitdodgy/words_counted
  [2]: https://en.wikipedia.org/wiki/Kahlil_Gibran
