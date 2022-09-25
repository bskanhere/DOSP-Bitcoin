-module(work).
-export([mine_coins/4]).

mine_coins(Pid, K, Start_val, End_val) ->
  if
    Start_val < End_val ->
      Random = binary_to_list(base64:encode(integer_to_binary(Start_val))),
      RandomStr = binary_to_list(re:replace(Random, "\\W", "", [global, {return, binary}])),
      Val = "bkanhere;"++RandomStr,
      Hash = io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256, Val))]),
      Zero_string = string:join(lists:duplicate(K, "0"), ""),
      Hash_prefix = string:sub_string(Hash, 1, K),
      if
        Hash_prefix == Zero_string ->
          Pid ! {mined, Hash, Val};
        true ->
          1
      end,
      mine_coins(Pid, K, Start_val+1, End_val);
    true ->
      Pid ! {worker_done}
  end.
