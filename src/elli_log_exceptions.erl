%% @doc Elli middleware that will log the exceptions that result in
%%      500 status responses.
%% @end
%%%-------------------------------------------------------------------------
-module(elli_log_exceptions).

-export([config/1,
         preprocess/2,
         handle/2,
         handle_event/3]).

config(Opts) ->
    Level = proplists:get_value(level, Opts, error),
    Stacktrace = proplists:get_bool(include_stacktrace, Opts),
    {Level, Stacktrace}.

preprocess(Req, _) ->
    Req.

handle(_Req, _Config) ->
    ignore.

handle_event(Event, [Req, Exception, Stacktrace], {Level, IncludeStacktrace})
  when Event =:= request_error ;
       Event =:= request_throw ;
       Event =:= request_exit ->
    Format = format(IncludeStacktrace),
    Args = args(Req, Exception, Stacktrace, IncludeStacktrace),
    logger:log(Level, Format, Args);
handle_event(_Event, _Args, _Config) ->
    ok.

%%


format(true) ->
    "path=~s exception=~p stacktrace=~p";
format(false) ->
    "path=~s exception=~p".

args(Req, Exception, Stacktrace, true) ->
    [elli_request:raw_path(Req), Exception, Stacktrace];
args(Req, Exception, _Stacktrace, false) ->
    [elli_request:raw_path(Req), Exception].
