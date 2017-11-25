-module(ccmapred).
-export([read_data/1]).

read_data(File_Name) ->
  {ok, BIN} = file:read_file(File_Name),
  List = binary_to_list(BIN),
  io:format("list: ~p~n", [?MODULE]).
