%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Jun 2016 20:17
%%%-------------------------------------------------------------------
-module(su_database_logic).
-author("tihon").

-include("su_database.hrl").

-define(REQUEST_TIMEOUT, 5000).

%% API
-export([read_one/5, write/2]).

-spec read_one(any(), bson:document() | map(), bson:document() | map(), proplists:proplist(), integer()) ->
  {ok, map()} | undefined.
read_one(Collection, Key, Projector, ReadOpts, Timeout) ->
  Res = mongoc:transaction_query(?DATABASE_POOL,
    fun(Conf) ->
      mongoc:find_one(Conf, Collection, Key, Projector, 0)
    end, ReadOpts, Timeout),
  case maps:size(Res) of
    0 -> undefined;
    _ -> {ok, Res}
  end.

write(Collection, Document) ->
  mongoc:transaction(?DATABASE_POOL,
    fun(Worker) -> mc_worker_api:insert(Worker, Collection, Document, {<<"w">>, 1}) end, ?REQUEST_TIMEOUT).