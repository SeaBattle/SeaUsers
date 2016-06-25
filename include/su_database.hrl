%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-author("tihon").

-define(DATABASE_POOL, su_db_pool).

%% database collections
-define(USERS_COLLECTION, <<"users">>).

%% read modes
-define(MASTER, [{rp_mode, primary}]).
-define(SLAVE, [{rp_mode, secondaryPreferred}]).