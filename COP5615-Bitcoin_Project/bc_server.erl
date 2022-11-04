-module(bc_server).
-import(string,[substr/3]).
-import(string,[equal/2]).
-compile(export_all).

start(N_Zero , N_Nodes) ->
    Prefix_Zero = lists:concat(lists:duplicate(N_Zero, "0")),
    io:fwrite("Number of Zeroes : ~p || String representation of zeroes ~p\n\n", [N_Zero, Prefix_Zero]),
    spawn_nodes(N_Nodes, Prefix_Zero, node(), self()),
    register(server, self()),
    statistics(runtime),
    {Time, _} = timer:tc(bc_server, bc_server, [0, N_Nodes, Prefix_Zero]),
    {_, Time_CPU_Since_Last_Call} = statistics(runtime),
    io:fwrite("Total clock time(Time/1000): ~p\nTotal CPU time: ~p\n CPU time/RunTime: ~p\n", [Time/1000, Time_CPU_Since_Last_Call, Time_CPU_Since_Last_Call/(Time/1000)]).

mine_coins(Prefix_Zero, Parent) ->
    Random_String = random_string_generator(),
    Generated_Hash = hash_computor(Random_String),
    BitCoin = equal(Prefix_Zero,substr(Generated_Hash,1,string:length(Prefix_Zero))),
    if BitCoin == true ->
        Parent ! {Generated_Hash, Random_String, self()},
        receive
            {mine} -> mine_coins(Prefix_Zero, Parent)
        after
            10000 -> ok
        end;
        true -> mine_coins(Prefix_Zero, Parent)
    end.

hash_computor(Random_String) ->
    Generated_Hash = io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256, Random_String))]),
    Generated_Hash.

random_string_generator() ->
    Base64_string = base64:encode(crypto:strong_rand_bytes(8)),
    Gen_string = binary_to_list(Base64_string),
    Final_string = string:join(["aadithyakandeth", Gen_string], ";"),
    Final_string.

bc_server(234, _, _) ->
    ok;
bc_server(Coins_found, N_Nodes, Prefix_Zero) ->
    receive
        {Generated_Hash, Random_String, Finder} ->
            io:fwrite("Coins found: ~p :\nBitCoin :  ~p and Generated Hash is ~p \nFound by ~p\n\n", [Coins_found+1, Random_String, Generated_Hash, Finder]),
            Finder ! {mine},
            bc_server(Coins_found+1, N_Nodes, Prefix_Zero);
        {node, Node} ->
            io:fwrite("Connection request by ~p Spawning.. \n \n", [Node]),
            code_transfer(Node),
            spawn(bc_server, spawn_nodes, [N_Nodes, Prefix_Zero, Node, self()]),
            bc_server(Coins_found, N_Nodes, Prefix_Zero)
    end.

code_transfer(Node) ->
    {Mod, Bin, File} = code:get_object_code(bc_server),
    rpc:multicall([Node], code, load_binary, [Mod, File, Bin]),
    ok.

spawn_nodes(0, _, _, _) ->
    ok;
spawn_nodes(N, Prefix_Zero, Node, Parent) ->
    spawn(Node, bc_server, mine_coins, [Prefix_Zero, Parent]),
    spawn_nodes(N - 1, Prefix_Zero, Node, Parent).




