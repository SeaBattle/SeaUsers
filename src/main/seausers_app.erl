-module(seausers_app).

-behaviour(application).

-include_lib("seaconfig/include/sc_headers.hrl").

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  Ret = su_super_sup:start_link(),
  {ok, _} = su_database_man:init(),
  {ok, _} = su_cache_man:init(),
  true = register_node(),
  Ret.

stop(_State) ->
  ok.


%% @private
register_node() ->
  sc_conf_holder:set_inorder_conf(?USER_SERVICE_HOSTS, <<"127.0.0.1">>).  %TODO - invent the way to register node by public ip. May be use os var?