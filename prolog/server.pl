%% server.pl
%% swi-prolog
%% compile: ['server.pl']
%%
%% Http+Pengine server hosting static files and pengine safe-predicates
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

:- module(pengine_server,
          [
           server/1,
           stop/1,
           long_query/1,
           prompt_test/1,
           output_test/0,
           output_test2/1
          ]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).
:- use_module(library(pengines)).
:- use_module(pengine_sandbox:library(pengines)).
:- use_module(pengine_sandbox:library(lists)).
:- use_module(library(sandbox)).
:- multifile sandbox:safe_primitive/1.

%% Safe predicates accessible from remote client
sandbox:safe_primitive(lists:member(_,_)).
sandbox:sandbox_allowed_goal(long_query(_)).
sandbox:sandbox_allowed_goal(prompt_test(_)).
sandbox:sandbox_allowed_goal(output_test).

:- http_handler(root(.), http_reply_from_files('./static/', []), [prefix]).
%%%===================================================================
%%% API
%%%===================================================================

%% Start http/pengine server on Port
%% server(+).
%% server(Port).
server(Port):-
    http_server(http_dispatch, [port(Port)]).

%% Stop http/pengine server on Port
%% stop(+).
%% stop(Port).
stop(Port):-
    http_stop_server(Port, []).


%% infinite loop query, used for testing stop-command to pengine
%% long_query(+).
%% long_query(_).
long_query(X):-
    long_query(X).

%% Sends Prompt to the parent pengine and waits for input.
%% prompt_test(-).
%% prompt_test(_).
prompt_test(prompt_test_success(Input)):-
	pengine_input(prompt_test, Input).

%% Sends Term to the parent pengine or thread.
%% output_test.
output_test:-
    pengine_output(output_test_success).

%% Sends Two terms to the parent pengine or thread.
%% output_test2(-).
%% output_test2(_).
output_test2(done):-
    pengine_output(output_test2_first),
    pengine_output(output_test2_second).
