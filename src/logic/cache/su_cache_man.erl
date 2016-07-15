%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Jun 2016 20:17
%%%-------------------------------------------------------------------
-module(su_cache_man).
-author("tihon").

-include_lib("seaconfig/include/sc_headers.hrl").

%% API
-export([get_salt/1, set_salt/2, init/0, set_user_online/2]).

init() ->
  ok = application:load(eredis_cluster),
  Nodes = sc_conf_holder:get_conf(?CACHE_HOSTS_CONF, <<"127.0.0.1:30001">>),
  PoolSize = sc_conf_holder:get_conf(?CACHE_SIZE_CONF, 5),
  PoolOverflow = sc_conf_holder:get_conf(?CACHE_OVERFLOW_CONF, 100),
  PoolOverflowTTL = sc_conf_holder:get_conf(?CACHE_OVERFLOW_TTL_CONF, 5000),
  PoolOverflowCheck = sc_conf_holder:get_conf(?CACHE_OVERFLOW_CHECK_CONF, 1000),
  application:set_env(eredis_cluster, init_nodes, form_init_nodes(Nodes)),
  application:set_env(eredis_cluster, pool_size, PoolSize),
  application:set_env(eredis_cluster, pool_max_overflow, PoolOverflow),
  application:set_env(eredis_cluster, overflow_ttl, PoolOverflowTTL),
  application:set_env(eredis_cluster, overflow_check_period, PoolOverflowCheck),
  application:ensure_all_started(eredis_cluster).

-spec get_salt(binary()) -> {ok, binary()} | {error, binary() | atom()}.
get_salt(Id) ->
  eredis_cluster:q([<<"GET">>, <<<<"auth_conf_">>/binary, Id/binary>>]).

-spec set_salt(binary(), binary()) -> {ok, binary()} | {error, binary() | atom()}.
set_salt(Id, Salt) ->
  eredis_cluster:q([<<"SETEX">>, <<<<"auth_conf_">>/binary, Id/binary>>, <<"5">>, Salt]).

-spec set_user_online(binary(), binary()) -> {ok, binary()} | {error, binary() | atom()}.
set_user_online(UID, Token) ->
  eredis_cluster:q([<<"SET">>, <<<<"user_">>/binary, UID/binary>>, <<"5">>, Token]).

%% @private
form_init_nodes(BinHosts) ->
  Hosts = binary:split(BinHosts, <<",">>, [global]),
  lists:foldl(
    fun(Host, A) ->
      [Host, Port] = binary:split(Host, <<":">>),
      [{binary_to_list(Host), binary_to_integer(Port)} | A]
    end, [], Hosts).