defmodule Hemingway.CounterTest do
  use ExUnit.Case, async: true
  doctest Hemingway.Counter

  test "counts tokens in a string" do
    assert Hemingway.Counter.count("There was a star danced") == 5
  end

  test "counts characters in a string" do
    assert Hemingway.Counter.char_count("There was a star danced") == 23
  end

  test "tokens returns a list of tokens from a string" do
    assert Hemingway.Counter.tokens("There was a star danced") == ["There", "was", "a", "star", "danced"]
  end

  test "unique_tokens returns a list of unique tokens from a string" do
    assert Hemingway.Counter.unique_tokens("hi bye hi bye") == ["hi", "bye"]
  end

  test "unique_token_count counts unique tokens in a string" do
    assert Hemingway.Counter.unique_token_count("hi bye hi bye") == 2
  end
end
