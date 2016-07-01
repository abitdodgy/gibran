defmodule Gibran.Soundex do
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

  def encode(string) do
    string
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

  defp convert_glyph(char) do
    Map.get(@scores, char)
  end
end
