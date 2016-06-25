-module(seausers_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  Ret = su_super_sup:start_link(),
  {ok, _} = su_database_man:init(),
  Ret.

stop(_State) ->
  ok.