Gibran
=========

> Yesterday is but today's memory, and tomorrow is today's dream.

![Gibran](http://d.gr-assets.com/authors/1353732571p5/6466154.jpg)

[Gibran][2] is an Elixir natural language processor. Lofty goals for Gibran: include

- Metaphone phonetic coding system
- Soundex algorithm
- Porter Stemming algorithm
- String similarity as [described by Simon White](http://www.catalysoft.com/articles/StrikeAMatch.html)

Currently, Gibran ships with the following features:

- Token count, unique token count, and character count
- Average characters per token
- `HashDict`s of tokens and their frequencies, lengths, and densities
- The longest token(s) and its length
- The most frequent token(s) and its frequency
- Unique tokens
- Levenshtein distance algorithm

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

By default Gibran uses the following regular expression to tokenise strings: `~r/[^\p{L}'-]/u`. You can provide your own regular expression through the `pattern` option. You can combine `pattern` with `exclude` to create sophisticated tokenisation strategies.

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

Gibran provides a shortcut for working with strings directly (instead of running them through the tokeniser first).

```elixir
Gibran.from_string(str, :token_count, opts: [exclude: &String.length(&1) < 4])
# => 6
```

To avoid inconsistencies that arise from character-casing, Gibran normalises input before applying transformations.

### Levenshtein distance

Ordinary use:

```elixir
iex(1)> Gibran.Levenshtein.distance("kitten", "sitting")
3
 ```

The Levenshtein distance for the same string is 0.

```elixir
iex(2)> Gibran.Levenshtein.distance("snail", "snail")
0
```

The Levenshtein distance is case-sensitive.

```elixir 
iex(3)> Gibran.Levenshtein.distance("HOUSEBOAT", "houseboat")
9
```

The function can accept charlists as well as strings.

```elixir
 iex(4)> Gibran.Levenshtein.distance('jogging', 'logger')
 4
 ```

The `doctests` contain extensive usage examples. Please take a look there for more details.

  [1]: https://github.com/abitdodgy/words_counted
  [2]: https://en.wikipedia.org/wiki/Kahlil_Gibran
