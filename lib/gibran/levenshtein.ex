defmodule Gibran.Levenshtein do
	@spec distance(list | binary,  list | binary) :: integer
	def distance(string, string), do: 0

	def distance(string, []), do: length(string)
	
	def distance([], string), do: length(string)

	def distance(source, target)
	when is_binary(source) and is_binary(target) do
		distance(String.graphemes(source), String.graphemes(target))
	end

	def distance(source, target)
	when is_list(source) and is_list(target) do
		rec_lev(source, target, :lists.seq(0, length(target)), 1)
	end


	defp rec_lev([src_head | src_tail], target, distlist, step) do
		rec_lev(src_tail, target, lev_dist(target, distlist, src_head, [step], step), step + 1)
	end

	defp rec_lev([], _target, distlist, _step) do
		List.last(distlist)
	end


	defp lev_dist([target_head | target_tail], [distlist_head | distlist_tail], source_char, new_distlist, last_dist)
	when distlist_tail > 0 do
		min = Enum.min([last_dist + 1, hd(distlist_tail) + 1, distlist_head + delta(target_head, source_char)])
		lev_dist(target_tail, distlist_tail, source_char, new_distlist ++ [min], min)
	end

	defp lev_dist([], _, _, new_distlist, _), do: new_distlist


	defp delta(a, a), do: 0
	defp delta(_a, _b), do: 1
end