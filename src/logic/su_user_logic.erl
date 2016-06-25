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

-define(SALT_LEN, 10).
-define(SECRET_ITERATIONS, 100).
-define(SECRET_LENGTH, 20).
-define(DATABASE_TIMEOUT, 5000).

%% API
-export([register/3, login/2]).

-spec register(binary(), binary(), binary()) -> true | {false, error_code()}.
register(Email, Name, Lang) ->
  UEmail = su_utils:to_lower(Email),
  case su_database_logic:read_one(?USERS_COLLECTION, #{?EMAIL_HEAD => UEmail}, #{<<"_id">> => true}, ?MASTER, ?DATABASE_TIMEOUT) of
    undefined ->
      create_user(Email, Lang, Name);
    _ ->
      {false, ?USER_EXISTS}
  end.

-spec login(binary(), binary()) -> true | {true, map()} | {false, error_code()}.
login(UID, Secret) ->
  auth_user(UID, Secret). %TODO save online user to cache. May be save it's node, pid and put it to monitor?


%% @private
%% If email is proper (contains @) - send password to email.
%% If we can't send email with password for some reason - just return it to user in a response.
create_user(Email, Lang, Name) ->
  Id = uuid:to_binary(uuid:uuid4()),
  Pass = su_utils:get_random_non_numeric_string(10),
  Hash = su_utils:hash_secret(Pass),
  PassBin = list_to_binary(Pass),
  {{true, _}, _} = su_database_logic:write(?USERS_COLLECTION,
    #{?EMAIL_HEAD => Email, ?UID_HEAD => Id, ?NAME_HEAD => Name, ?VICTORIES_HEAD => 0, ?LOOSES_HEAD => 0, ?SECRET_HEAD => Hash}),
  case su_email_man:send_password(Lang, Email, PassBin, Name) of
    true -> true;
    false -> {true, PassBin}
  end.

%% @private
%% Return {true, Conf} if secret needs to be calculated
%% Return true if auth is ok
%% Return {false, ErrCode} in case of auth error
auth_user(UID, Secret) -> %TODO on first step there will no Secret. Refator me
  case su_cache_logic:get_salt(UID) of
    {ok, undefined} ->  %no previous step - generate salt, save it and send to user
      #{?SALT_HEAD := Salt} = Conf = generate_auth_conf(),
      {ok, <<"OK">>} = su_cache_logic:set_salt(UID, Salt),
      {true, Conf};
    {ok, Salt} ->
      check_secret(UID, Secret, Salt);
    _Error ->
      {false, ?SERVER_ERROR}
  end.

%% @private
generate_auth_conf() ->
  Salt = base64:encode(crypto:strong_rand_bytes(?SALT_LEN)),
  #{?SALT_HEAD => Salt, ?SECRET_LEN_HEAD => ?SECRET_LENGTH, ?SECRET_ITERATIONS_HEAD => ?SECRET_ITERATIONS}.

%% @private
check_secret(UID, Secret, Salt) ->
  case su_database_logic:read_one(?USERS_COLLECTION, #{?UID_HEAD => UID}, #{?SECRET_HEAD => true}, ?SLAVE, ?DATABASE_TIMEOUT) of
    {ok, #{?SECRET_HEAD := OriginalSecret}} ->
      case calculate_secret(OriginalSecret, Salt) of
        Secret -> true;
        _ -> {false, ?INCORRECT_AUTH}
      end;
    _ -> {false, ?NO_SUCH_USER}
  end.

%% @private
calculate_secret(Original, Salt) ->
  {ok, Key} = pbkdf2:pbkdf2(sha256, Original, Salt, ?SECRET_ITERATIONS, ?SECRET_LENGTH),
  list_to_binary(su_utils:bin_to_hexstr(Key)).