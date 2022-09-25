-module(server).
-export([run/1, server/6, spawn_processes/6]).

  server(K, Start_val, Batch, NW, NC, Continue) ->
    receive
      {start_work} ->
        spawn_processes(self(), K, Start_val, 6, Batch, 0),
        server(K, Start_val+4*Batch, Batch, 6, 0, Continue);

      {worker_done} ->
        if
          Continue == false ->
            if
              NW == 1 ->
                if
                  NC == 0 ->
                    NWN = 0,
                    self() ! {stop_complete};
                  true ->
                    NWN = 0
                end;
              true ->
                NWN = NW -1
            end;
          true ->
            NWN = NW,
            spawn(work, mine_coins, [self(), K, Start_val, Start_val+Batch])
        end,
        server(K, Start_val+Batch, Batch, NWN, NC, Continue);

      {stop_initiate} ->
        io:fwrite("Stopping Server.~n"),
        server(K, Start_val+Batch, Batch, NW, NC, false);

      {stop_complete} ->
        {_, Time1} = statistics(runtime),
        {_, Time2} = statistics(wall_clock),
        U1 = Time1 * 1000,
        U2 = Time2 * 1000,
        io:format("Code time=~p (~p) microseconds~n", [U1,U2]),
        io:fwrite("Server Stopped.~n");

      {mined, Coin, Val} ->
        io:fwrite("~p \t ~p ~n", [Coin, Val]),
        server(K, Start_val, Batch, NW, NC, Continue);

      {client_hello, Client} ->
        io:fwrite("Client Connected~n"),
        Client ! {work, K, Start_val, Start_val+Batch},
        server(K, Start_val+Batch, Batch, NW, NC+1, Continue);

      {client_done, Client} ->
        if
          Continue == false ->
            Client ! {work_complete},
            if
              NC == 1 ->
                if
                  NW == 0 ->
                    NCN = 0,
                    self() ! {stop_complete};
                  true ->
                    NCN = 0
                end;
              true ->
                NCN = NC -1
            end;
          true ->
            NCN = NC,
            Client ! {work, K, Start_val, Start_val+Batch}
        end,
        server(K, Start_val+Batch, Batch, NW, NCN, Continue)
    end.

  spawn_processes(Pid, K, Start_val, Times, Batch, I) ->
    if I < Times ->
        spawn(work, mine_coins, [Pid, K, Start_val, Start_val+Batch]),
        spawn_processes(Pid, K, Start_val+Batch, Times, Batch, I+1);
      true ->
        1
    end.

  run(Args) ->
    statistics(runtime),
    statistics(wall_clock),
    PID = spawn(server, server, [Args, 0, 1000000, 0, 0, true]),
    register(server, PID),
    PID ! {start_work},
    PID.

