%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(su_email_man).
-author("tihon").

-include("su_headers.hrl").
-include("su_localization.hrl").
-include_lib("seaconfig/include/sc_headers.hrl").

%% API
-export([send_password/4]).

-spec send_password(binary(), binary(), binary(), binary()) -> boolean().
send_password(Lang, Email, Password, Name) ->
  case su_resource_holder:get_html_resource(Lang, ?NEW_PASS_HTML) of
    undefined ->
      false;
    String ->
      Html = io_lib:format(String, [Name, Password]),
      validate_send(Name, Email, Html, ?ACTIVATION_SUBJECT(Lang))
  end.


%% @private
validate_send(Name, Email, Html, Theme) ->
  case binary:match(Email, <<"@">>) of
    nomatch -> false;
    _ ->
      Domain = sc_conf_holder:get_conf(?MAILGUN_DOMAIN),
      ApiUrl = sc_conf_holder:get_conf(?MAILGUN_API_URL),
      ApiKey = sc_conf_holder:get_conf(?MAILGUN_API_KEY),
      if
        Domain /= undefined andalso ApiKey /= undefined andalso ApiUrl /= undefined ->
          spawn(
            fun() ->
              email_adapter_mailgun:send(binary_to_list(<<ApiUrl/binary, <<"/">>/binary, Domain/binary>>), binary_to_list(ApiKey),
                {Name, Email}, {<<"SeaServer">>, <<"noreply@seabattle.com">>}, Theme, [{<<"html">>, list_to_binary(Html)}], [])
            end),
          true;
        true ->
          false
      end
  end.