%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Jul 2016 21:23
%%%-------------------------------------------------------------------
-module(su_http_handler).
-author("tihon").

-include("su_headers.hrl").

%% Cowboy callbacks
-export([init/2, reply/2, reply/3]).

init(Req, Opts) ->
  Req2 = act(cowboy_req:path(Req), Req, Opts),
  {ok, Req2, Opts}.

-spec reply(cowboy_req:req(), integer()) -> cowboy_req:req().
reply(Req, _) ->
  cowboy_req:reply(404, [
    {<<"content-type">>, <<"text/html">>}
  ], <<"Not found">>, Req).

reply(Req, 200, Data) ->
  cowboy_req:reply(200, [
    {<<"content-type">>, <<"application/json">>}
  ], Data, Req).


%% @private
act(<<"/register/", _/binary>>, Req, _) ->
  {ok, Body, Req2} = cowboy_req:body(Req, [{length, infinity}]),
  Decoded = jsone:decode(Body, [{object_format, map}]),
  Result = su_user_logic:register(Decoded),
  reply(Req2, 200, jsone:encode(Result));
act(<<"/login/", _/binary>>, Req, _) ->
  {ok, Body, Req2} = cowboy_req:body(Req, [{length, infinity}]),
  Decoded = jsone:decode(Body, [{object_format, map}]),
  Result = su_user_logic:login(Decoded),
  reply(Req2, 200, jsone:encode(Result));
act(_, Req, _) ->
  reply(Req, 404).