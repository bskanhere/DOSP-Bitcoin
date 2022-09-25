-module(client).
-export([start/1, client/1]).

  start(Server) ->
    Client = spawn(client, client, [Server]),
    {server, Server} ! {client_hello, Client}.

  client(Server) ->
    receive
      {work, K, Start_val, End_val} ->
        spawn(work, mine_coins, [self(), K, Start_val, End_val]),
        client(Server);

      {mined, Coin, Val} ->
        {server, Server} ! {mined, Coin, Val},
        client(Server);

      {worker_done} ->
        {server, Server} ! {client_done, self()},
        client(Server);

      {work_complete} ->
        io:fwrite("Stopping Client. ~n")
    end.