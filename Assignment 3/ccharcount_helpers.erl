-module(ccharcount_helpers).
-compile(export_all).

read_data(File_Name) ->
  {ok, BIN} = file:read_file(File_Name),
  Raw_List = binary_to_list(BIN),
  Clean_List = string:to_lower(re:replace(Raw_List, "[^a-zA-Z]", "", [global, {return, list}])), %Remove all non-alphabetical characters
  Bucket_Size = round( length(Clean_List) / 20 ),
  Buckets = split(Clean_List, Bucket_Size),
  io:fwrite("Loaded, cleaned and split~n"),
  Buckets.

split([],_)->[];
split(List,Length)->
  S1=string:substr(List,1,Length),
  case length(List) > Length of
    true->S2=string:substr(List,Length+1,length(List));
    false->S2=[]
  end,
  [S1]++split(S2,Length).

count(Ch, [],N)->N;
count(Ch, [H|T],N) ->
  case Ch==H of
    true-> count(Ch,T,N+1);
    false -> count(Ch,T,N)
  end.


join([],[])->[];
join([],R)->R;
join([H1 |T1],[H2|T2])->
  {C,N}=H1,
  {C1,N1}=H2,
  [{C1,N+N1}]++join(T1,T2).
