-module(mapreduce).
-export([example_go/0]).

start(Module, Buckets, Map_Func, Reduce_Func) ->
  Reduce_PID = spawn(Module, Reduce_Func, [length(Buckets), 0, [], self()]),
  Alph=[$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s,$t,$u,$v,$w,$x,$y,$z],
  lists:foreach(fun(Bucket) -> spawn(Module, Map_Func, [Bucket, Alph, Reduce_PID, []]) end, Buckets),

  receive
    Results ->
      Results
  end.

example_go() ->
start(mapreduce, read_in_data("war.txt"), map_bucket, reduce_results).

read_in_data(Filename) ->
  {ok, BIN} = file:read_file(Filename),
  List = string:to_lower(binary_to_list(BIN)),
  Buckets = split(List, (length(List)/20)),
  io:fwrite("Loaded and split~n"),
  Buckets.

map_bucket(Bucket, [], Reduce_PID, Results) -> Reduce_PID ! Results;
map_bucket(Bucket, [KEY|T], Reduce_PID, Results) ->
  VALUE = count(KEY, Bucket, 0),
  New_Results = Results ++ [{[KEY], VALUE}],
  map_bucket(Bucket, T, Reduce_PID, New_Results).


count(KEY, [], VALUE) -> VALUE;
count(KEY, [Grapheme|T], VALUE) ->
  case KEY == Grapheme of
    true-> count(KEY, T, VALUE+1);
    false -> count(KEY, T, VALUE)
  end.

reduce_results(N,Accum,Results,Main_PID) when Accum < N ->
  receive
    [] ->
      reduce_results(N, Accum+1, Results, Main_PID);
    Result ->
      join(Result, Results),
      exit(done_early)
  end;
reduce_results(_, _, Results, Main_PID) ->
  Main_PID ! Results.


join([],[])->[];
join([],R)->R;
join([H1 |T1],[H2|T2])->
  {C,N}=H1,
  {C1,N1}=H2,
  [{C1,N+N1}]++join(T1,T2).

split([],_)->[];
split(List,Length)->
  S1=string:substr(List,1,Length),
  case length(List) > Length of
    true->S2=string:substr(List,Length+1,length(List));
    false->S2=[]
  end,
  [S1]++split(S2,Length).
