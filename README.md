## Project 1 
Group Members: <br/>
1. Akanksha Miharia <br/>
2. Bhushan Kanhere<br/>

## Instruction on how to run
While starting the erlang nodes use the following commands - <br/>
server node --> erl -name server@{ip address of the server} -setcookie {secret} <br/>
client node -->  erl -name client@{ip address of the client} -setcookie {secret} <br/>
IMP - The secret value of the cookie has to be SAME across nodes for them to be able to connect. <br/>
1. Compile work -> c(work). <br/>
2. Compile server -> c(server). <br/>
3. Compile client -> c(client). <br/>
4. Run server -> server:run(k). <br/>
5. Run client -> client:start(server node name). <br/>

## Implementation Logic
### Work Logic
work.erl has the logic for an actor to process strings incrementally from the given start value to the given end value and mine bitcoins that have the given number of leading 0s.
### Server Logic
server.erl spawns a server process that selects and keeps track of ranges of incremental strings that are to be provided to the worker/client for mining bitcoins. The server spawns 8 workers on the same node for mining. Clients using the server's node name can connect with the servers and also participate in the mining process. Whenever the bitcoin is found from either the server itself or the client, it prints the bitcoin.
### Client Logic
The client uses the server's node name(IP address) to connect with the server and get a range of string values to process. Whenever it finds a bitcoin, it sends a message with details to the server.

## Work Unit
The work unit is 1,000,000. The reason for choosing this value is that, the processing time is very large compared to the time of spawning and killing the actors.
This also ensures that if a client fails the amount of unit not getting processed is not very large. Moreover, this ensures all clients checkin with the server from time to time which helps the server to keep track of all the actors and ensures the actors can shut down when the user wishes to.
Also, the chances of various actors processing the same string reduces.

## Result of running program for input 4

##  Ratio of CPU time to REAL TIME
Program was run on 8-core M1 and 2-core i5

## The coin with the most number of leading 0s we mined


## Largest number of working machines on which we tested our code
Client machines having 3 terminal open. 
We connected four i-7 octa core machines locally where 1 was the server with all cores utilized at 100% and 3 miners with one process running on them and utilising only one cpu 100% as we are running only one process on the client.
