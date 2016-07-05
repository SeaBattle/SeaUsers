%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(su_database_man).
-author("tihon").

-include("su_database.hrl").
-include("su_headers.hrl").
-include_lib("seaconfig/include/sc_headers.hrl").

-define(DATABASE_TIMEOUT, 5000).


%% API
-export([init/0, find_user_by_uid/1, is_email_exists/1]).

init() ->
  Hosts = sc_conf_holder:get_conf(?DATABASE_HOSTS_CONF),
  PoolDefaults = application:get_env(database, []),
  PoolConf = form_pool_conf(PoolDefaults),
  WorkerConf = form_worker_conf(),
  {ok, Topology} = mongo_api:connect(unknown, Hosts, PoolConf, WorkerConf),  %topology is registered under ?DBPOOL locally
  mc_topology:get_pool(Topology), %get topology in order to initialise pool
  {ok, Topology}.

find_user_by_uid(UID) ->
  su_database_logic:read_one(?USERS_COLLECTION, #{?UID_HEAD => UID}, #{?SECRET_HEAD => true}, ?SLAVE, ?DATABASE_TIMEOUT).

is_email_exists(Email) ->
  undefined /= su_database_logic:read_one(?USERS_COLLECTION, #{?EMAIL_HEAD => Email}, #{<<"_id">> => true}, ?MASTER, ?DATABASE_TIMEOUT).


%% @private
form_pool_conf(Conf) ->
  PoolSize = sc_conf_holder:get_conf(?DATABASE_SIZE_CONF),
  Overflow = sc_conf_holder:get_conf(?DATABASE_OVERFLOW_CONF),
  OverTTL = sc_conf_holder:get_conf(?DATABASE_OVERFLOW_TTL_CONF),
  OverCheckPeriod = sc_conf_holder:get_conf(?DATABASE_OVERFLOW_CHECK_CONF),
  [
    {pool_size, PoolSize},
    {max_overflow, Overflow},
    {overflow_ttl, OverTTL},
    {overflow_check_period, OverCheckPeriod},
    {register, ?DATABASE_POOL}
  ] ++ Conf.

%% @private
form_worker_conf() ->
  Login = sc_conf_holder:get_conf(?DATABASE_LOGIN_CONF),
  Password = sc_conf_holder:get_conf(?DATABASE_PASS_CONF),
  Database = sc_conf_holder:get_conf(?DATABASE_DB_CONF),
  lists:filter(fun({_, A}) -> A /= undefined end, [{login, Login}, {database, Database}, {password, Password}]).