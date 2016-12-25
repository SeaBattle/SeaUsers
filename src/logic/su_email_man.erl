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
-include("su_conf_headers.hrl").

-define(API_DOMAIN(A, D), binary_to_list(<<A/binary, <<"/">>/binary, D/binary>>)).

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
      Domain = seaconfig:get_value(?MAILGUN_DOMAIN),
      ApiUrl = seaconfig:get_value(?MAILGUN_URL),
      ApiKey = seaconfig:get_value(?MAILGUN_KEY),
      if
        Domain /= undefined andalso ApiKey /= undefined andalso ApiUrl /= undefined ->
          spawn(
            fun() ->
              email_adapter_mailgun:send(?API_DOMAIN(ApiUrl, Domain), binary_to_list(ApiKey), {Name, Email},
                {<<"SeaServer">>, <<"noreply@seabattle.com">>}, Theme, [{<<"html">>, list_to_binary(Html)}], [])
            end),
          true;
        true ->
          false
      end
  end.