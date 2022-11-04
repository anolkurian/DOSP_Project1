## COP5615 - DOSP Project 1
**Team Members:**
1.  Aadithya Kandeth - 69802791
2. Anol Kurian Vadakkeparampil - 56268544

**Objective**
This project intends to hash using SHA 256 and mine bitcoins based on the number of leading zeros that is passed as an input to the program.
It has been developed in erlang and uses the actor model.  The client and server are run on 2 separate machines and multiple clients can be added in order to spawn more worker nodes.

**bc_server.erl ( System 1)**
The server is run on system 1 and does the following:
start: Takes in the number of nodes to spawn and the required number of leading zeros to be found as input arguments. 
receive: The receive function can accepts two types of messages. Messages received from the workers are printed to indicate that a coin has been found. Messages received from the client leads to further actors being spawned. These new actors are also used for mining. The process continues till 234 (arbitrary) coins are found. 
spawn_nodes: Spawns nodes based on the input passed.
mine_coins:  Finds the bitcoin based on the number of leading zeroes.
hash_computor: Generates the hash using SHA 256 on the randomly generated string.
random_string_generator: generates a random string that is prefixed by the team member names and the UFID.

**bc_client.erl (System 2)**
The client only contains one function. It takes in the server name as an argument to setup a connection with the server. The current node name is then passed as a message to the server after which actors are spawned on the client. These actors continue the job.

**1. Worker process**
Steps:
1. Generate a random string
2. Calculate the hash for that string
3. Keep running until the leading zero condition is satisfied.
4. If a message is received form the client, more actors are spawned.
5. Any coins found by the client nodes are printed on the server itself.
6. The actors are killed once a certain number of coins are found.
7. The relevant statistics are calculated once the program is terminated  

**OUTPUT**
The following screenshots show the output for running the program across a single server and 2 clients running on different machines.
Starting Server:
![Image](https://raw.githubusercontent.com/Aadithya97/Bitcoin_Miner_Images/main/Starting%20server.png) 

Client 1 Connecting:
![Image](https://raw.githubusercontent.com/Aadithya97/Bitcoin_Miner_Images/main/Client1_connection.png)

Client 2 Connecting:
![Image](https://raw.githubusercontent.com/Aadithya97/Bitcoin_Miner_Images/main/Client2_connection.png)

Client Side:
![Image](https://raw.githubusercontent.com/Aadithya97/Bitcoin_Miner_Images/main/clientside_aadi.png)

Statistics:
![Image](https://raw.githubusercontent.com/Aadithya97/Bitcoin_Miner_Images/main/statistics1.png)

Statistics with 2 clients and 1 server working:
Size of the work unit = 24
For input 4 (4 leading zeros):
Total Clock time = 18029.465
Total CPU time = 88875
CPU time/Run time ratio = 4.929430795644796

**Largest coin found**
The most number of leading zeroes found was 7. The program took around 10 minutes to find a coin with 7 leading zeroes.
7 zeroes:
![Image](https://raw.githubusercontent.com/Aadithya97/Bitcoin_Miner_Images/main/7%20zeroes.png)
Trying with 8 zeroes (No coins found after half an hour):
![Image](https://raw.githubusercontent.com/Aadithya97/Bitcoin_Miner_Images/main/8%20zeroes.png)


**Max number of Systems Used for Mining**
For testing, five systems were used as different clients but the program would work with more.
