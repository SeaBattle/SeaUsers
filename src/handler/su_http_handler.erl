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
-include("su_localization.hrl").

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
act(<<"/register/", _/binary>>, Req, _) ->   %TODO code is to complex, move getting register params somewhere else
  {ok, Body, Req2} = cowboy_req:body(Req, [{length, infinity}]),
  Decoded = jsone:decode(Body, [{object_format, map}]),
  {Email, Name, Lang} = get_register_params(Decoded),
  Result = su_user_logic:register(Email, Name, Lang),
  Encoded = form_register_result(Result),
  reply(Req2, 200, jsone:encode(Encoded));
act(<<"/login/", _/binary>>, Req, _) ->
  {ok, Body, Req2} = cowboy_req:body(Req, [{length, infinity}]),
  Decoded = jsone:decode(Body, [{object_format, map}]),
  %TODO find step to run proper login fun
  reply(Req2, 200);
act(_, Req, _) ->
  reply(Req, 404).

%% @private
get_register_params(#{?EMAIL_HEAD := Email, ?NAME_HEAD := Name, ?LANG_HEAD := Lang}) ->
  {Email, Name, Lang};
get_register_params(#{?EMAIL_HEAD := Email, ?NAME_HEAD := Name}) ->
  {Email, Name, ?DEFAULT_LANG}.

%% @private
form_register_result({true, Pass}) ->  ok;
form_register_result(true) ->  ok;
form_register_result({false, Code}) ->  ok.

