-module(estimating_pi).
-export([run_pi_estimator/0]).

run_pi_estimator() ->
  estimate_pi(1, 1, 0.0, "", "0").

estimate_pi(DENOM, SIGN, TOTAL, STR_TOTAL, STR_PREV_TOTAL) when STR_TOTAL == STR_PREV_TOTAL -> TOTAL;
estimate_pi(DENOM, SIGN, TOTAL, STR_TOTAL, STR_PREV_TOTAL) ->
  NEW_TOTAL = SIGN*4*(1/DENOM) + TOTAL,
  estimate_pi(DENOM+2, SIGN*-1, NEW_TOTAL, io_lib:format("~.5f", [TOTAL]), io_lib:format("~.5f", [NEW_TOTAL])).
