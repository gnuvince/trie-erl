-module(trie_test).

-include("trie.hrl").
-include_lib("eunit/include/eunit.hrl").

new_test() ->
    ?assertEqual(trie:new(), #trie_node{
        end_of_entry = false,
        children = #{}
    }).

insert_contains_test() ->
    Trie = lists:foldl(fun(Entry, Acc) ->
            trie:insert(Entry, Acc)
        end, trie:new(), [<<"foo">>, <<"bar">>, <<"baz">>, <<"fo">>]),
    ?assert(trie:contains(<<"foo">>, Trie)),
    ?assert(trie:contains(<<"fo">>, Trie)),
    ?assert(trie:contains(<<"bar">>, Trie)),
    ?assert(trie:contains(<<"baz">>, Trie)),
    ?assertNot(trie:contains(<<"f">>, Trie)),
    ?assertNot(trie:contains(<<"fooo">>, Trie)).

advance_test() ->
    InnerTrie = trie:insert(<<"oo">>, trie:new()),
    FullTrie = trie:insert(<<"foo">>, trie:new()),
    ?assertEqual(trie:advance($f, FullTrie), InnerTrie),
    ?assertEqual(trie:advance($x, FullTrie), undefined).
