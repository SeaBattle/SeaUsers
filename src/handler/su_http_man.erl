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
  Port = sc_conf_holder:get_conf(?USER_SERVICE_HTTP_PORT, 8080),
  Acceptors = sc_conf_holder:get_conf(?USER_SERVICE_HTTP_ACCEPTORS, 100),
  Dispatch = cowboy_router:compile(
    [
      {'_',
        [
          {'_', su_http_handler, []}
        ]
      }
    ]),
  Buf = get_buffer_size(),
  {ok, _} = cowboy:start_http(http_handler, Acceptors, [{port, Port}, {buffer, Buf}], [{env, [{dispatch, Dispatch}]}]),
  ok.


%% @private
get_buffer_size() ->
  {ok, S} = gen_tcp:listen(0, []),
  {ok, Res} = inet:getopts(S, [sndbuf, recbuf]),
  gen_tcp:close(S),
  Max = max(proplists:get_value(sndbuf, Res), proplists:get_value(recbuf, Res)),
  round(Max + Max * 0.05).  %max + 5%