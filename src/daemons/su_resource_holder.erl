%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% Holds resources and configuration
%%% @end
%%%-------------------------------------------------------------------
-module(su_resource_holder).
-author("tihon").

-behaviour(gen_server).

-include("su_headers.hrl").
-include("su_localization.hrl").

%% API
-export([start_link/0, get_html_resource/2]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).
-define(HTML_ETS, sea_htmls).
-define(RES_UPDATE_INTERVAL, 15000). %15 sec
%% TODO move resources to database/consul
-define(HTML_DIR, "html/").

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================
%% Get html file's content for sending mails to user.
-spec get_html_resource(binary(), binary()) -> undefined | string().
get_html_resource(Lang, ResourceName) ->
  case ets:lookup(?HTML_ETS, {Lang, ResourceName}) of
    [] ->
      case ets:lookup(?HTML_ETS, {?DEFAULT_LANG, ResourceName}) of
        [] -> undefined;
        [{_, Content}] -> Content
      end;
    [{_, Content}] -> Content
  end.

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
  {ok, State :: #state{}} | {ok, State :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term()} | ignore).
init([]) ->
  ets:new(?HTML_ETS, [named_table, protected, {read_concurrency, true}, {write_concurrency, true}]),
  erlang:send_after(?RES_UPDATE_INTERVAL, self(), update_res),
  {ok, #state{}, 0}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
    State :: #state{}) ->
  {reply, Reply :: term(), NewState :: #state{}} |
  {reply, Reply :: term(), NewState :: #state{}, timeout() | hibernate} |
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), Reply :: term(), NewState :: #state{}} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: #state{}) ->
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_cast(_Request, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #state{}) ->
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_info(update_res, State) ->   %update html files
  load_files(),
  erlang:send_after(?RES_UPDATE_INTERVAL, self(), update_res),
  {noreply, State, hibernate};
handle_info(timeout, State) ->
  ok = load_files(),
  {noreply, State, hibernate};
handle_info(_Info, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #state{}) -> term()).
terminate(_Reason, _State) ->
  ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
    Extra :: term()) ->
  {ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%% @private
-spec load_files() -> ok | {false, Reason :: any()}.
load_files() ->
  Path = su_utils:get_priv_dir(seausers) ++ ?HTML_DIR,
  case file:list_dir(Path) of
    {ok, []} -> {false, empty};
    {ok, Locales} ->
      load_locales(Path, Locales);
    Other ->
      {false, Other}
  end.

%% @private
-spec load_locales(string(), list()) -> ok.
load_locales(Path, Locales) ->
  lists:foreach(
    fun(Locale) ->
      Full = Path ++ "/" ++ Locale,
      {ok, Files} = file:list_dir(Full),
      load_htmls(list_to_binary(Locale), Full ++ "/", Files)
    end, Locales).

%% @private
-spec load_htmls(binary(), string(), list()) -> ok.
load_htmls(Locale, Path, Files) ->
  lists:foreach(
    fun(File) ->
      case lists:suffix(".html", File) of
        true -> %html file, load it
          {ok, Content} = file:read_file(Path ++ File),
          ets:insert(?HTML_ETS, {{su_utils:to_lower(Locale), list_to_binary(File)}, binary_to_list(Content)});
        false -> ok %not html file
      end
    end, Files).