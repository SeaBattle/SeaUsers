%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Dec 2016 11:45
%%%-------------------------------------------------------------------
-author("tihon").

-define(POOL_SIZE, <<"user_service/db/pool_size">>).
-define(DATABASE, <<"user_service/db/name">>).
-define(DB_USER, <<"user_service/db/user">>).
-define(DB_PASS, <<"user_service/db/pass">>).
-define(MAILGUN_URL, <<"user_service/mailgun/url">>).
-define(MAILGUN_KEY, <<"user_service/mailgun/key">>).
-define(MAILGUN_DOMAIN, <<"user_service/mailgun/domain">>).
-define(SALT_LEN, <<"user_service/salt_len">>).
-define(SECRET_ITERATIONS, <<"user_service/iterations">>).
-define(SECRET_LENGTH, <<"user_service/secret_len">>).
-define(HTTP_PORT, <<"user_service/http/port">>).
-define(HTTP_ACCEPTORS, <<"user_service/http/acceptors">>).
-define(CACHE_SIZE, <<"user_service/cache/size">>).
-define(CACHE_OVERFLOW, <<"user_service/cache/overflow">>).
-define(CACHE_OVERFLOW_TTL, <<"user_service/cache/overflow_ttl">>).
-define(CACHE_OVERFLOW_CHECK, <<"user_service/cache/overflow_check">>).