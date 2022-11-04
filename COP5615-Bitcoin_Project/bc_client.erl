-module(bc_client).
-export([start/1]).

start(Node_Server)->
    net_adm:ping(Node_Server),
    {server, Node_Server} ! {node, node()}.