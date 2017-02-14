defmodule Gibran.SoundexTest do
  use ExUnit.Case
  doctest Gibran.Soundex

  test ~S"""
    when given a name, encode function returns a score as the 
    first character of the name, followed by a dash and a three-digit score
    """ 
  do
    washington = Gibran.Soundex.encode("Washington")
    assert washington == "W-252"
  end

  test "encode function appends zeroes to names with no additional consonants" do
    lee = Gibran.Soundex.encode("Lee")
    assert lee == "L-000"
  end

  test "encode function retains the first letter of names, even as vowels" do
    arthur = Gibran.Soundex.encode("Arthur")
    assert arthur == "A-636"
  end

  test "encode function treats double letter instances as a single instance" do
    gutierrez = Gibran.Soundex.encode("Gutierrez")
    assert gutierrez == "G-362"
  end

  test "adjacent characters with the same score are counted as a single character" do
    pfister = Gibran.Soundex.encode("Pfister")
    jackson = Gibran.Soundex.encode("Jackson")
    assert pfister == "P-236" and jackson == "J-250"
  end

  test ~S"""
    names with vowels (A, E, I, O, U) separating two same-valued 
    consonants have both consonants coded
    """
  do
    tymczak = Gibran.Soundex.encode("Tymczak")
    assert tymczak == "T-522" 
  end

  test ~S"""
    names with two same-scoring consonants separated by 'H' or 'W' characters 
    only code the first character
    """
  do
    ashcraft = Gibran.Soundex.encode("Ashcraft")
    assert ashcraft == "A-261"
  end

  test "similar sounding names have the same Soundex score" do
    ashcroft = Gibran.Soundex.encode "Ashcroft"
    ashcraft = Gibran.Soundex.encode "Ashcraft"
    assert ashcroft == ashcraft
  end

  test ~S"""
    names with diacritic marks are treated as non-accented latin characters
    """
  do
    diacritic = Gibran.Soundex.encode "Núñez"
    latinized = Gibran.Soundex.encode "Nunez"
    assert  diacritic == latinized
  end

  test "encode function treats charlists the same as strings" do
    charlist = Gibran.Soundex.encode 'Asamov'
    string = Gibran.Soundex.encode "Asamov"

    assert charlist == string
  end

end
