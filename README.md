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
- `Map`s of tokens and their frequencies, lengths, and densities.
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

By default Gibran uses the following regular expression to tokenise strings: `~r/[^\p{L}'-]/u`. However, you can provide your own regular expression through the `pattern` option. You can also combine `pattern` with `exclude` to create sophisticated tokenisation strategies.

```
Tokeniser.tokenise(string, exclude: &String.length(&1) < 4) |> Counter.token_count
# => 6
```

The `exclude` option accepts a string, a function, a regular expression, or a list combining any one or more of those types.


```elixir
# Using `exclude` with a function.
Tokeniser.tokenise("Kingdom of the Imagination", exclude: &(String.length(&1) < 10))
["imagination"]

# Using `exclude` with a regular expression.
Tokeniser.tokenise("Sand and Foam", exclude: ~r/and/)
["foam"]

# Using `exclude` with a string.
Tokeniser.tokenise("Eye of The Prophet", exclude: "eye of")
["the", "prophet"]

# Using `exclude` with a list of a combination of types.
Tokeniser.tokenise("Eye of The Prophet", exclude: ["eye", &(String.ends_with?(&1, "he")), ~r/of/])
["prophet"]
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
