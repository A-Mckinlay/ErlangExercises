-module(ccmapred).
-export([begin_map_reduce/1, map_bucket/4, reduce_results/4]).
-import(ccharcount_helpers, [count/3, join/2, read_data/1]).

begin_map_reduce(File_Name) ->
  Buckets = read_data(File_Name),
  start(Buckets, map_bucket, reduce_results).

start(Buckets, Map_Func, Reduce_Func) ->
  Reduce_PID = spawn(?MODULE, Reduce_Func, [self(), length(Buckets), 0, []]),
  lists:foreach(fun(Bucket) -> spawn(?MODULE, Map_Func, [Bucket, lists:seq($a,$z),Reduce_PID, []]) end, Buckets),

  receive
    Results ->
      Results
  end.

map_bucket(Bucket, [], Reduce_PID, Results) -> Reduce_PID ! Results;
map_bucket(Bucket, [Letter|Rest_Of_Alphabet], Reduce_PID, Results) ->
  Value = count(Letter, Bucket, 0),
  New_Results = Results ++ [{[Letter], Value}],
  map_bucket(Bucket, Rest_Of_Alphabet, Reduce_PID, New_Results).

reduce_results(Main_PID, Num_Of_Buckets, Accum, Results) when Accum == Num_Of_Buckets ->
  Main_PID ! Results;
reduce_results(Main_PID, Num_Of_Buckets, Accum, Results) when Accum < Num_Of_Buckets ->
  receive
    Result_Set ->
      New_Results = join(Results, Result_Set),
      reduce_results(Main_PID, Num_Of_Buckets, Accum+1, New_Results)
  end.
