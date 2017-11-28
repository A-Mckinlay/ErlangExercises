-module(uniqua).
-export([count_unique_entries/2, run_set_example/0, run_comprehension_example/0]).

run_set_example() ->
  count_unique_entries_set_method([2,5,3,6,2,7,8,5,6]).
run_comprehension_example() ->
  count_unique_entries([2,5,3,6,2,7,8,5,6], []).

count_unique_entries_set_method(LIST) ->
  sets:size(sets:from_list(LIST)).

count_unique_entries([], RES_LIST) -> io:fwrite("Unique items: ~p~n", [RES_LIST]), io:fwrite("Number of unique items: ~p~n", [length(RES_LIST)]);
count_unique_entries([H|T], RES_LIST) ->
  case lists:member(H, RES_LIST) of
    true -> count_unique_entries(T, RES_LIST);
    false -> count_unique_entries(T, RES_LIST ++ [H])
  end.
