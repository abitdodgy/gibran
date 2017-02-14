defmodule Gibran.Soundex do
  @moduledoc ~S"""
  This module encodes strings according to the Soundex standard as defined 
  by the United States National Archives and Records Administration (NARA).
  
  Soundex is a phonetic algorithm for indexing names by sound, as pronounced 
  in English. The goal is for homophones to be encoded to the same 
  representation so that they can be matched despite minor differences in spelling.

  Every Soundex code consists of a letter and three numbers, such as `W-252`. 
  The letter is always the first letter of the word. The numbers are 
  assigned to the remaining letters of the word according to the Soundex 
  guide shown below. Zeroes are added at the end if necessary to produce a 
  four-character code. Additional letters are disregarded.

  Soundex Coding Guide for Glyphs:
  |score    | Glyph(s)               |
  | :-----: | --------               |
  |    1    | B, F, P, V             |
  |    2    | C, G, J, K, Q, S, X, Z |
  |    3    | D, T                   |
  |    4    | L                      |
  |    5    | M, N                   |
  |    6    | R                      |

  Disregard the letters A, E, I, O, U, H, W, and Y
  """

  @scores %{"B" => 1, "F" => 1, "P" => 1,
            "V" => 1, "C" => 2, "G" => 2,
            "J" => 2, "K" => 2, "Q" => 2, 
            "S" => 2, "X" => 2, "Z" => 2,
            "D" => 3, "T" => 3, "L" => 4,
            "M" => 5, "N" => 5, "R" => 6, 
            "A" => "A", "E" => "E", 
            "I" => "I", "O" => "O", 
            "U" => "U"}

  @padding [0, 0, 0]

  @doc ~S"""
  The core function of Soundex. Encodes strings and charlists into its 
  their associated Soundex scores expressed as strings. 

  ## Examples

    Homphones:
    Words that sound the same, but are spelled differently, have the same code.

        iex(1)> Gibran.Soundex.encode "Smyth"
        "S-530"
        iex(2)> Gibran.Soundex.encode "Smith"
        "S-530"

    Too Many or Too Few Consonants:
    Words will always result in a four-character code (plus hyphen). Zeroes are 
    added at the end if necessary; additional letters are disregarded.

        iex(3)> Gibran.Soundex.encode "Washington"
        "W-252"
        iex(4)> Gibran.Soundex.encode "Lee"
        "L-000"

    Double-Consonants:
    If the word has any double letters, they should be treated as one letter.

        iex(5)> Gibran.Soundex.encode "Gutierrez"
        "G-362"

    Same-Scoring Adjacent Letters:
    If the word has different letters side-by-side that have the same number 
    in the Soundex coding guide, they should be treated as one letter.

        iex(6)> Gibran.Soundex.encode "Jackson"
        "J-250"

    Consonant Separators:
    If a vowel (A, E, I, O, U) separates two consonants that have the same 
    Soundex code, the consonant to the right of the vowel is coded. 
        iex(7)> Gibran.Soundex.encode "Tymczak"
        "T-522"

    If "H" or "W" separate two consonants that have the same Soundex code, 
    the consonant to the right of the vowel is not coded.

        iex(8)> Gibran.Soundex.encode "Ashcraft"
        "A-261"

    Diacritc Marks:
    This function will account for diacritic marks and reduce glyphs to their basic,
    Latinized form.
        iex(9)> Gibran.Soundex.encode "Núñez"
        "N-520"
        iex(10)> Gibran.Soundex.encode "Nunez"
        "N-520"

    Case-Insensitivity and Charlists:
    This function will accept charlists and is also case-insensitive.
        iex(11)> Gibran.Soundex.encode 'Pfister'
        "P-236"
        iex(12)> Gibran.Soundex.encode "pFiSteR"
        "P-236"
  """
  @spec encode(binary | list) :: binary
  def encode(charlist) when is_list(charlist) do
    charlist
      |> List.to_string
      |> encode
  end

  def encode(string) do
    string
      |> String.normalize(:nfd)
      |> String.upcase
      |> String.codepoints
      |> do_encode
  end

  defp do_encode(glyphs) do
    [char | _rest] = glyphs
    do_encode(glyphs, char)
  end

  defp do_encode(glyphs, char) do
    glyphs
      |> Enum.map(&convert_glyph(&1))
      |> reduce_glyphs
      |> Enum.filter(&is_integer(&1))
      |> add_first_letter(char)
      |> add_padding
      |> Enum.take(4)
      |> format
  end

  defp reduce_glyphs(glyphs)
  when is_list(glyphs) do
    reduce_glyphs(glyphs, [])
  end

  defp reduce_glyphs([], acc), do: Enum.reverse acc

  defp reduce_glyphs([nil | rest], acc) do
    reduce_glyphs(rest, acc)
  end

  defp reduce_glyphs([c1, nil | rest], acc) do
    reduce_glyphs([c1 | rest], acc)
  end

  defp reduce_glyphs([c1 | []], acc) do
    reduce_glyphs([], [c1 | acc]) 
  end

  defp reduce_glyphs([c1, c1 | rest], acc) do
    reduce_glyphs([c1 | rest], acc)
  end

  defp reduce_glyphs([c1, c2 | rest], acc) do
    reduce_glyphs([c2 | rest], [c1 | acc])
  end

  defp add_padding(list), do: list ++ @padding

  defp add_first_letter([c1 | rest], char) do
    case is_same_score?(char, c1) do
      false -> 
        [char, c1 | rest]
      true ->
        [char | rest]
    end
  end

  defp format([char | rest]) do
    [char, "-", rest]
      |> List.flatten
      |> Enum.join
  end

  defp is_same_score?(char, point) do
    point == @scores[char]
  end

  defp convert_glyph(glyph) do
    Map.get(@scores, glyph)
  end
end
