%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Jun 2016 17:49
%%%-------------------------------------------------------------------
-author("tihon").

-define(DATABASE_POOL, su_db_pool).

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