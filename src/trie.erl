-module(trie).

-include("trie.hrl").

-export([
    new/0,
    insert/2,
    contains/2,
    advance/2
]).


-spec new() -> trie_node().
new() ->
    #trie_node{
        end_of_entry = false,
        children = #{}
    }.


-spec insert(binary(), trie_node()) -> trie_node().
insert(<<>>, #trie_node{} = Trie) ->
    Trie#trie_node{ end_of_entry = true };
insert(<<Byte, Rest/binary>>, #trie_node{ children = M } = Trie) ->
    ChildTrie = maps:get(Byte, M, trie:new()),
    Trie#trie_node{
        children = maps:put(Byte, insert(Rest, ChildTrie), M)
    }.


-spec contains(binary(), trie_node()) -> boolean().
contains(<<>>, #trie_node{ end_of_entry = EndOfEntry }) ->
    EndOfEntry;
contains(<<Byte, Rest/binary>>, Trie) ->
    case advance(Byte, Trie) of
        undefined ->
            false;
        #trie_node{} = ChildTrie ->
            contains(Rest, ChildTrie)
    end.


-spec advance(byte(), trie_node()) -> undefined | trie_node().
advance(Byte, #trie_node{ children = M }) ->
    maps:get(Byte, M, undefined).
