%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% Error codes
%%% @end
%%%-------------------------------------------------------------------
-author("tihon").

-type error_code() :: integer().
-export_type([error_code/0]).

%% Auth and registration
-define(INCORRECT_AUTH, 100).
-define(USER_EXISTS, 101).
-define(NO_SUCH_USER, 102).
-define(SALT_REQUIRED, 103).

-define(SERVER_ERROR, 500).