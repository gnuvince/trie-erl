-record(trie_node, {
    end_of_entry :: boolean(),
    children :: #{byte() => #trie_node{}}
}).

-type trie_node() :: #trie_node{}.

-export_type([
    trie_node/0
]).
