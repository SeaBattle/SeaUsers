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

-include_lib("seaconfig/include/sc_headers.hrl").

%% API
-export([init_http_handler/0]).

init_http_handler() ->
  Port = sc_conf_holder:get_conf(?USER_SERVICE_HTTP_PORT_CONF, 8080),
  Acceptors = sc_conf_holder:get_conf(?USER_SERVICE_HTTP_ACCEPTORS_CONF, 100),
  Dispatch = cowboy_router:compile(
    [
      {'_',
        [
          {'_', su_http_handler, []}
        ]
      }
    ]),
  {ok, _} = cowboy:start_http(http_handler, Acceptors, [{port, Port}], [{env, [{dispatch, Dispatch}]}]),
  ok.