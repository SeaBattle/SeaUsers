%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(su_database_man).
-author("tihon").

-include("su_headers.hrl").

%% API
-export([init/0]).

init() ->
  Hosts = sc_conf_holder:get_conf(?DATABASE_HOSTS),
  PoolDefaults = application:get_env(database, []),
  PoolConf = form_pool_conf(PoolDefaults),
  WorkerConf = form_worker_conf(),
  {ok, Topology} = mongo_api:connect(unknown, Hosts, PoolConf, WorkerConf),  %topology is registered under ?DBPOOL locally
  mc_topology:get_pool(Topology), %get topology in order to initialise pool
  {ok, Topology}.


%% @private
form_pool_conf(Conf) ->
  PoolSize = sc_conf_holder:get_conf(?DATABASE_SIZE),
  Overflow = sc_conf_holder:get_conf(?DATABASE_OVERFLOW),
  OverTTL = sc_conf_holder:get_conf(?DATABASE_OVERFLOW_TTL),
  OverCheckPeriod = sc_conf_holder:get_conf(?DATABASE_OVERFLOW_CHECK),
  [
    {pool_size, PoolSize},
    {max_overflow, Overflow},
    {overflow_ttl, OverTTL},
    {overflow_check_period, OverCheckPeriod},
    {register, ?DATABASE_POOL}
  ] ++ Conf.

%% @private
form_worker_conf() ->
  Login = sc_conf_holder:get_conf(?DATABASE_LOGIN),
  Password = sc_conf_holder:get_conf(?DATABASE_PASS),
  Database = sc_conf_holder:get_conf(?DATABASE_DB),
  lists:filter(fun({_, A}) -> A /= undefined end, [{login, Login}, {database, Database}, {password, Password}]).