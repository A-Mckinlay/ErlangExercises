-module(hamluniqua).
-import(uniqua, [count_unique_entries/2]).
-export([parse_hamlet/0]).

read_file() ->
  {ok, BINARY} = file:read_file("../examples/hamlet.txt"),
  string:lexemes(binary_to_list(string:lowercase(BINARY)), "0123456789[]?,.--!()#;\\/*\":+%= " ++ [[$\r,$\n]]).

parse_hamlet() ->
  count_unique_entries(read_file(), []).
