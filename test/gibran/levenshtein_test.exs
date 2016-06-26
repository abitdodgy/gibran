defmodule Gibran.LevenshteinTest do
  use ExUnit.Case
  doctest Gibran.Levenshtein

  test "When given the same string, the Distance function returns 0" do
  	assert Gibran.Levenshtein.distance("donkey", "donkey") == 0
  end

  test "Distance function returns the Levenshtein distance between two strings" do
    assert Gibran.Levenshtein.distance("kitten", "sitting") == 3
  end

  test "Distance function is case-sensitive" do
  	assert Gibran.Levenshtein.distance("GRAPES", "grapes") == 6
  end

  test "Distance function accepts charlists" do
  	assert Gibran.Levenshtein.distance('jogging', 'logger') == 4
  end

end
