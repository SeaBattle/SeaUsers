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
-define(VICTORIES_HEAD, <<"victories">>).  %user's victory statistics
-define(LOOSES_HEAD, <<"looses">>).    %user's loose statistics
-define(PASSWORD_HEAD, <<"password">>). %password, replied to user in case email can not be send
-define(SALT_HEAD, <<"salt">>).        %server-generated salt. Used for auth
-define(SECRET_LEN_HEAD, <<"secret_len">>).  %length of generated secret. Used for auth
-define(SECRET_ITERATIONS_HEAD, <<"secret_iter">>).  %number of iterations to generate secret. Used for auth
-define(RESULT_HEAD, <<"result">>).
-define(CODE_HEAD, <<"code">>).