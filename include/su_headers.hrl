%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-author("tihon").

%% Database conf vars
-define(DATABASE_HOSTS, <<"database/hosts">>).
-define(DATABASE_DB, <<"database/pool_size">>).
-define(DATABASE_LOGIN, <<"database/pool_size">>).
-define(DATABASE_PASS, <<"database/pool_size">>).
-define(DATABASE_SIZE, <<"database/pool_size">>).
-define(DATABASE_OVERFLOW, <<"database/pool_size">>).
-define(DATABASE_OVERFLOW_TTL, <<"database/pool_size">>).
-define(DATABASE_OVERFLOW_CHECK, <<"database/pool_size">>).

%% Email conf vars
-define(MAILGUN_DOMAIN, <<"email/domain">>).
-define(MAILGUN_API_URL, <<"email/api_url">>).
-define(MAILGUN_API_KEY, <<"email/api_key">>).

%% Html templates
-define(NEW_PASS_HTML, <<"su_new_password.html">>).

%% Key headers
-define(EMAIL, <<"email">>).  %user's unique email (or any other string)
-define(UID, <<"uid">>).    %user's unique id (is generated is su_user_logic as uuid)
-define(NAME, <<"name">>).  %user's name
-define(VICTORIES, <<"victories">>).  %user's victory statistics
-define(LOOSES, <<"looses">>).    %user's loose statistics
-define(SECRET, <<"secret">>).    %user's password (is generated in su_user_logic)