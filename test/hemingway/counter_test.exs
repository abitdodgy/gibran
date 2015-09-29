defmodule Hemingway.CounterTest do
  use ExUnit.Case, async: true

  test "counts tokens in a string" do
    assert Hemingway.Counter.count("There was a star danced") == 5
  end

  test "counts characters in a string" do
    assert Hemingway.Counter.char_count("There was a star danced") == 23
  end

  test "tokenize returns a list of tokesn from a string" do
    assert Hemingway.Counter.tokens("There was a star danced") == ["There", "was", "a", "star", "danced"]
  end
end
