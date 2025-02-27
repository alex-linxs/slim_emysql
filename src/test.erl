-module(test).
-export([run/0,start/0,run1/0,run2/0,run3/0,run4/0,run_error/0]).

run() ->
    %% 启动 Emysql 进程
    application:start(emysql),
    %% 添加连接池（名字是 my_pool）
    emysql:add_pool(hello_pool, [{size, 1},{user, "root"},{password, "root"},{host, "localhost"},{port, 3306},
        {database, "fs"},{encoding, utf8}]),
    %% 创建表
    emysql:execute(hello_pool, <<"CREATE TABLE test_users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL,
        birthdate DATE,
        is_active BOOLEAN DEFAULT TRUE
    );">>),
    %% 插入数据
    emysql:execute(hello_pool, <<"INSERT INTO test_users (username, email, birthdate, is_active) VALUES ('test', 'test@runoob.com', '1990-01-01', true);">>),
    %% 查询
    Result = emysql:execute(hello_pool, <<"select * from test_users">>),
    io:format("~n~p~n", [Result]).

start() ->
    %% 启动 Emysql 进程
    application:start(emysql),
    %% 添加连接池（名字是 my_pool）
    emysql:add_pool(hello_pool, [{size, 1},{user, "root"},{password, "root"},{host, "127.0.0.1"},{port, 3306},
        {database, "fs"},{encoding, utf8}]).

run1() ->
    db:get_all(<<"select * from test_users">>).

run2() ->
    db:get_row(<<"select * from test_users">>).

run3() ->
    db:get_row(<<"select `username` from test_users where id = 1">>).

run4() ->
    db:insert(<<"INSERT INTO test_users (username, email, birthdate, is_active) VALUES ('test3', 'test3@runoob.com', '1993-01-01', true)">>).

run_error() ->
    db:get_row(<<"select `username1` from test_users where id = 1">>).
