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
-include("su_codes.hrl").
-include("su_localization.hrl").
-include("su_conf_headers.hrl").

-define(SALT_LEN_DEF, 10).
-define(SECRET_ITERATIONS_DEF, 100).
-define(SECRET_LENGTH_DEF, 20).

-define(DEFAULT_NAME, <<"Vasya">>).
-define(CHECK_FILL(X, M, D),
  case maps:is_key(X, M) of
    true -> M;
    false -> M#{X = D}
  end).

%% API
-export([register/1, login/1]).

%% Email is needed.
-spec register(map()) -> map().
register(#{?EMAIL_HEAD := Email, ?NAME_HEAD := Name, ?LANG_HEAD := Lang}) ->
  UEmail = su_utils:to_lower(Email),
  case su_database_man:is_email_exists(UEmail) of %TODO email is unique, handle error on write
    true -> #{?RESULT_HEAD => false, ?CODE_HEAD => ?USER_EXISTS};
    false ->
      case create_user(Email, Lang, Name) of
        {true, Id} ->
          #{?RESULT_HEAD => true, ?UID_HEAD => Id, ?CODE_HEAD => ?OK};
        {true, Id, Pass} ->
          #{?RESULT_HEAD => true, ?UID_HEAD => Id, ?PASSWORD_HEAD => Pass, ?CODE_HEAD => ?OK}
      end
  end;
register(Map = #{?EMAIL_HEAD := _}) ->
  MapWithLang = ?CHECK_FILL(?LANG_HEAD, Map, ?DEFAULT_LANG),
  MapWithName = ?CHECK_FILL(?NAME_HEAD, MapWithLang, ?DEFAULT_NAME),
  register(MapWithName);
register(_) ->
  #{?RESULT_HEAD => false, ?CODE_HEAD => ?INCORRECT_ARGUMENTS}.

%% UID for step1, UID and Secret for step2 needed.
-spec login(map()) -> map().
login(#{?UID_HEAD := UID}) -> %% Return salt and auth conf to user, save salt to cache.
  #{?SALT_HEAD := Salt} = Conf = generate_auth_conf(),
  {ok, <<"OK">>} = su_cache_man:set_salt(UID, Salt),
  Conf#{?RESULT_HEAD => true};
login(#{?UID_HEAD := UID, ?SECRET_HEAD := Secret, ?USER_TOKEN := Token}) -> %get auth conf from cache, auth user and register online.
  case su_cache_man:get_salt(UID) of
    {ok, undefined} -> #{?RESULT_HEAD => false, ?CODE_HEAD => ?SALT_REQUIRED};
    {ok, Salt} ->
      case check_secret(UID, Secret, Salt) of
        true ->
          {ok, <<"OK">>} = su_cache_man:set_user_online(UID, Token),
          #{?RESULT_HEAD => true, ?CODE_HEAD => ?OK};
        {false, Reason} ->
          #{?RESULT_HEAD => false, ?CODE_HEAD => Reason}
      end;
    _Error -> #{?RESULT_HEAD => false, ?CODE_HEAD => ?SERVER_ERROR}
  end;
login(_) ->
  #{?RESULT_HEAD => false, ?CODE_HEAD => ?INCORRECT_ARGUMENTS}.


%% @private
%% If email is proper (contains @) - send password to email.
%% If we can't send email with password for some reason - just return it to user in a response.
create_user(Email, Lang, Name) ->
  Pass = su_utils:get_random_non_numeric_string(10),
  Hash = su_utils:hash_secret(Pass),
  PassBin = list_to_binary(Pass),
  {true, Id} = su_database_man:create_user(Email, Name, Hash),
  case su_email_man:send_password(Lang, Email, PassBin, Name) of
    true -> {true, Id};
    false -> {true, Id, PassBin}
  end.

%% @private
generate_auth_conf() ->
  SaltLen = seaconfig:get_value(?SALT_LEN, ?SALT_LEN_DEF),
  Iterations = seaconfig:get_value(?SECRET_ITERATIONS, ?SECRET_ITERATIONS_DEF),
  SecretLen = seaconfig:get_value(?SECRET_LENGTH, ?SECRET_LENGTH_DEF),
  Salt = base64:encode(crypto:strong_rand_bytes(SaltLen)),
  #{?SALT_HEAD => Salt, ?SECRET_LEN_HEAD => SecretLen, ?SECRET_ITERATIONS_HEAD => Iterations}.

%% @private
check_secret(UID, Secret, Salt) ->
  case su_database_man:find_user_by_uid(UID) of
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