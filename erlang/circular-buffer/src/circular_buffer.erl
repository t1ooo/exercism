-module(circular_buffer).

-export([buf_create/1, buf_read/1, buf_size/1, buf_write/2, buf_write_attempt/2,
  create/1, handle_call/3, init/1,
  read/1, size/1, write/2, write_attempt/2]).

% api

create(Size) ->
    {ok, Pid} = gen_server:start_link(?MODULE, Size, []),
    Pid.

read(Pid) -> gen_server:call(Pid, read).

size(Pid) -> gen_server:call(Pid, size).

write(Pid, Item) -> gen_server:call(Pid, {write, Item}).

write_attempt(Pid, Item) ->
    gen_server:call(Pid, {write_attempt, Item}).

% gen server

init(Size) -> {ok, buf_create(Size)}.

handle_call(read, _, Buf) ->
    {Result, Buf2} = buf_read(Buf),
    {reply, Result, Buf2};
handle_call(size, _, Buf) ->
    Result = buf_size(Buf),
    {reply, Result, Buf};
handle_call({write, Item}, _, Buf) ->
    {Result, Buf2} = buf_write(Buf, Item),
    {reply, Result, Buf2};
handle_call({write_attempt, Item}, _, Buf) ->
    {Result, Buf2} = buf_write_attempt(Buf, Item),
    {reply, Result, Buf2}.

% buf

buf_create(Size) -> {queue:new(), Size}.

buf_read(Buf = {Q, Size}) ->
    case queue:is_empty(Q) of
      true -> {{error, empty}, Buf};
      false ->
        {{value, H}, Q2} = queue:out(Q),
        {{ok, H}, {Q2, Size}}
    end.

buf_size({_, Size}) -> {ok, Size}.

buf_write(Buf = {Q, Size}, Item) ->
    case queue:len(Q) < Size of
      true -> {ok, {queue:in(Item, Q), Size}};
      false ->
        {_, Buf2} = buf_read(Buf),
        buf_write(Buf2, Item)
    end.

buf_write_attempt(Buf = {Q, Size}, Item) ->
    case queue:len(Q) < Size of
      true -> buf_write(Buf, Item);
      false -> {{error, full}, Buf}
    end.
