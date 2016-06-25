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

-define(INCORRECT_AUTH, 100).
-define(USER_EXISTS, 101).
-define(NO_SUCH_USER, 102).
-define(SERVER_ERROR, 500).