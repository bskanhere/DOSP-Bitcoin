## Project 1 
Group Members: <br/>
1. Akanksha Miharia <br/>
2. Bhushan Kanhere<br/>

## Instruction on how to run
While starting the erlang nodes use the following commands - <br/>
server node --> erl -name server@{ip address of the server} -setcookie {secret} <br/>
client node -->  erl -name client@{ip address of the client} -setcookie {secret} <br/>
IMP - The secret value of the cookie has to be SAME across nodes for them to be able to connect. <br/>
<br/>
The Code base has 3 file - work.erl, server.erl, client.erl .
1. Compile work -> c(work). <br/>
2. Compile server -> c(server). <br/>
3. Compile client -> c(client). <br/>
4. Run server -> server:run(k). <br/>
5. Run client -> client:start(server node name). <br/>

## Implementation Logic
### Work Logic
work.erl has the logic for an actor to process strings incrementally from the given start value to the given end value and mine bitcoins that have the given number of leading 0s.
### Server Logic
server.erl spawns a server process that selects and keeps track of ranges of incremental strings that are to be provided to the worker/client for mining bitcoins.<br/> The server spawns 8 workers on the same node for mining. 8 chosen based on the number of cores.<br/> Clients using the server's node name can connect with the servers and also participate in the mining process.<br/> Whenever the bitcoin is found from either the server itself or the client, it prints the bitcoin.<br/> Server on receipt of message {stop_initiate} begins a gracefull shutdown waiting for all workers and clients to complete before finally shutting down.<br/>
### Client Logic
The client uses the server's node name(IP address) to connect with the server and get a range of string values to process. Whenever it finds a bitcoin, it sends a message with details to the server.

## Work Unit
The work unit is 1,000,000. The reason for choosing this value is that, the processing time is very large compared to the time of spawning and killing the actors.
This also ensures that if a client fails the amount of unit not getting processed is not very large. Moreover, this ensures all clients checkin with the server from time to time which helps the server to keep track of all the actors and ensures the actors can shut down when the user wishes to.
Also, the chances of various actors processing the same string reduces.

## Result of running program for input 4
Run on Intel Mac - 
```
(server@10.20.84.32)2> P = server:run(4).
<0.97.0>
"0000795ed5cb89dbab627fc6356a3a499ede5eef4a27938de31a667db80a33f2"       "bkanhere;NTAxMTc1Ng" 
"0000b003fa258faaaf52af227b465769f875e33e039216dee2c8bca0c8f276e6"       "bkanhere;MzAxNTgyNA" 
"0000a4e9c6112e94f6bfa2de07e3a858e7a9a51e4978dc310204a4e5b0d1a2fa"       "bkanhere;MjA2MzcwOA" 
"00007834468c77e5eedfd8b7cd11bdc3a2f79bb303150b48bf017e6e4036b24a"       "bkanhere;MjEwMzA3NQ" 
"0000c313decbe45238b589006a093d5329382d391cb293bf58f6187c6d4262d7"       "bkanhere;MzA3MzQ1Nw" 
"00007a39d99c56b9a35d16959d82162c6590dba21f293ca9d50105ab0bcfc181"       "bkanhere;MjE0ODk2NQ"
"0000b2f63168942dc3936c736935c482afa634905fa24d65cc6a3385266d0202"       "bkanhere;NzIyODUwOA" 
(server@10.20.84.32)3> P ! {stop_initiate}.
Stopping Server.
{stop_initiate}
"0000414cf7ecda0bbda944ff0e130801f18129a94df58f4c1ff968e905e95e66"       "bkanhere;NTU3OTc1Nw" 
"0000a1388f6cfba91a0d27375311e687109325937f68510fc842c2cba1e9d8df"       "bkanhere;NzIzNjI5Mg" 
"00008ac1d837e1f5803030f24077ff6587032c463900a4759184a55aabe34c7e"       "bkanhere;OTk3ODk2MA" 
"0000806b601c97c0c96f1306c8d9b0cc90cadca470c3b23b93de9244efd4bc32"       "bkanhere;OTk4Mjg0MQ" 
Code time=257874000 (73414000) microseconds
Server Stopped.        
```

##  Ratio of CPU time to REAL TIME
Program was run on 2-core i5 and 8-core M1 <br/>
i5 2 core - <br/>
Total CPU Time - 257874 ms 
Total Wall Clock Time - 73414 ms
Ratio - 3.5

Apple M1 8 Core - <br/>
Total CPU Time - 1398634 ms
Total Wall Clock Time - 234877 ms
Ratio - 5.95


## The coin with the most number of leading 0s we mined
Coin mined using M1 Mac as server and running 4 Clients on Mac Intel i5 - 


## Largest number of working machines on which we tested our code
Client machines having 3 terminal open. 
We connected four i-7 octa core machines locally where 1 was the server with all cores utilized at 100% and 3 miners with one process running on them and utilising only one cpu 100% as we are running only one process on the client.
