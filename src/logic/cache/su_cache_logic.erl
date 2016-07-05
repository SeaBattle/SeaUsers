%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Jun 2016 20:17
%%%-------------------------------------------------------------------
-module(su_cache_logic).
-author("tihon").

%% API
-export([get_salt/1, set_salt/2]).

%TODO make eredis_cluster configuration store in etcd

-spec get_salt(binary()) -> {ok, binary()} | {error, binary() | atom()}.
get_salt(Id) ->
  eredis_cluster:q([<<"GET">>, <<<<"auth_conf_">>/binary, Id/binary>>]).

-spec set_salt(binary(), binary()) -> {ok, binary()} | {error, binary() | atom()}.
set_salt(Id, Salt) ->
  eredis_cluster:q([<<"SETEX">>, <<<<"auth_conf_">>/binary, Id/binary>>, <<"5">>, Salt]).