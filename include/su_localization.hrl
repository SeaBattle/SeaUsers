%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-author("tihon").

-define(ENGLISH, <<"en">>).
-define(RUSSIAN, <<"ru">>).

-define(DEFAULT_LANG, ?ENGLISH).

-define(ACTIVATION_SUBJECT(LOCALE),
  case LOCALE of
    ?RUSSIAN -> <<"Морской бой, регистрация.">>;
    ?ENGLISH -> <<"SeaBattle registration">>;
    _ -> <<"SeaBattle registration">>
  end).