%%%-------------------------------------------------------------------
%%% @author Axel
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 2月 2025 21:41
%%%-------------------------------------------------------------------
-module(db).
-author("Axel").

%% API
-export([
  start/0,    %% 添加数据库连接池
  get_all/1,  %% 获取所有数据
  get_row/1,  %% 获取一行数据
  get_one/1,  %% 获取一个数据
  insert/1    %% 插入数据
]).

-include("emysql.hrl").
-define(POOL_ID, fs_pool).

start() ->
  case application:get_env(emysql, connect) of
    undefined ->
      skip;
    {ok, ConnectInfo} ->
      emysql:add_pool(?POOL_ID, ConnectInfo)
  end.

get_all(Sql) ->
  case emysql:execute(?POOL_ID, Sql) of
    #result_packet{rows = Rows} ->
      Rows;
    Error ->
      gen_error(Sql, Error)
  end.

get_row(Sql) ->
  case emysql:execute(?POOL_ID, Sql) of
    #result_packet{rows = Rows} ->
      case Rows of
        [] ->
          [];
        [R|_] ->
          R
      end;
    Error ->
      gen_error(Sql, Error)
  end.

get_one(Sql) ->
  case emysql:execute(?POOL_ID, Sql) of
    #result_packet{rows = Rows} ->
      case Rows of
        [] ->
          null;
        [[R]|_] ->
          R
      end;
    Error ->
      gen_error(Sql, Error)
  end.

insert(Sql) ->
  case emysql:execute(?POOL_ID, Sql) of
    #ok_packet{insert_id = InsertId} ->
      InsertId;
    Error ->
      gen_error(Sql, Error)
  end.

gen_error(Sql, Error) ->
  case Error of
    #error_packet{msg = Msg} ->
      io:format("~s, execute error, msg: ~s~n",[Sql, Msg]);
    _Error ->
      io:format("execute error: ~s~n",[_Error])
  end.