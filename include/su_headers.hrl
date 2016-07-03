%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-author("tihon").

%% Html templates
-define(NEW_PASS_HTML, <<"su_new_password.html">>).

%% Key headers
-define(EMAIL_HEAD, <<"email">>).  %user's unique email (or any other string)
-define(UID_HEAD, <<"uid">>).    %user's unique id (is generated is su_user_logic as uuid)
-define(NAME_HEAD, <<"name">>).  %user's name
-define(LANG_HEAD, <<"lang">>).  %user's language (for password's email localisation)
-define(VICTORIES_HEAD, <<"victories">>).  %user's victory statistics
-define(LOOSES_HEAD, <<"looses">>).    %user's loose statistics
-define(SECRET_HEAD, <<"secret">>).    %user's password (is generated in su_user_logic)
-define(SALT_HEAD, <<"salt">>).        %server-generated salt. Used for auth
-define(SECRET_LEN_HEAD, <<"secret_len">>).  %length of generated secret. Used for auth
-define(SECRET_ITERATIONS_HEAD, <<"secret_iter">>).  %number of iterations to generate secret. Used for auth