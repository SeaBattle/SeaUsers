%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Jul 2016 21:23
%%%-------------------------------------------------------------------
-module(su_http_man).
-author("tihon").

-include("su_conf_headers.hrl").

%% API
-export([init_http_handler/0]).

init_http_handler() ->
  Port = binary_to_integer(seaconfig:get_value(?HTTP_PORT, <<"8080">>)),
  Acceptors = binary_to_integer(seaconfig:get_value(?HTTP_ACCEPTORS, <<"100">>)),
  Dispatch = cowboy_router:compile(
    [
      {'_', %TODO split to different handlers instead of rt case
        [
          {'_', su_http_handler, []}
        ]
      }
    ]),
  {ok, _} = cowboy:start_http(http_handler, Acceptors, [{port, Port}], [{env, [{dispatch, Dispatch}]}]),
  ok.