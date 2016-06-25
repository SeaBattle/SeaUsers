%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Jun 2016 20:17
%%%-------------------------------------------------------------------
-module(su_user_logic).
-author("tihon").

-include("su_headers.hrl").
-include("su_database.hrl").
-include("su_codes.hrl").

-define(DATABASE_TIMEOUT, 5000).
-define(MASTER, [{rp_mode, primary}]).
-define(SLAVE, [{rp_mode, secondaryPreferred}]).

%% API
-export([register/3]).

register(Email, Name, Lang) ->
  UEmail = su_utils:to_lower(Email),
  case su_database_logic:read_one(?USERS_COLLECTION, #{?EMAIL => UEmail}, #{<<"_id">> => true}, ?MASTER, ?DATABASE_TIMEOUT) of
    undefined ->
      create_user(Email, Lang, Name);
    _ ->
      {false, ?USER_EXISTS}
  end.

login(UID, Secret) ->
  ok.


%% @private
%% If email is proper (contains @) - send password to email.
%% If we can't send email with password for some reason - just return it to user in a response.
create_user(Email, Lang, Name) ->
  Id = uuid:to_binary(uuid:uuid4()),
  Pass = su_utils:get_random_non_numeric_string(10),
  Hash = su_utils:hash_secret(Pass),
  PassBin = list_to_binary(Pass),
  {{true, _}, _} = su_database_logic:write(?USERS_COLLECTION,
    #{?EMAIL => Email, ?UID => Id, ?NAME => Name, ?VICTORIES => 0, ?LOOSES => 0, ?SECRET => Hash}),
  case su_email_man:send_password(Lang, Email, PassBin, Name) of
    true -> true;
    false -> {true, PassBin}
  end.