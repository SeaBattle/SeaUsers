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
-include("su_conf_headers.hrl").

-define(DATABASE_TIMEOUT, 5000).


%% API
-export([init/0, find_user_by_uid/1, create_user/3]).

init() ->
  {ok, [PgHost | _]} = seaconfig:get_service("postgres"),
  PoolSize = seaconfig:get_value(?POOL_SIZE),
  Db = seaconfig:get_value(?DATABASE),
  UN = seaconfig:get_value(?DB_USER),
  Pass = seaconfig:get_value(?DB_PASS),
  pgapp:connect([{host, PgHost}, {size, PoolSize}, {database, Db}, {username, UN}, {password, Pass}]).

find_user_by_uid(UID) ->
  pgapp:equery("select secret from users where uid = $1", [UID]).

create_user(Email, Name, Hash) ->
  pgapp:equery("insert into users (email, id, name, hash) values ($1, $2, $3, $4) RETURNING id", [Email, Name, Hash]).