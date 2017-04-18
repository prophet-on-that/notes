# The Trie Data Structure

A *trie* (pronounced the same as 'tree'), also known as a *prefix tree*
or *radix tree*, is a tree-like data structure requiring far less
space to store keys, when the keys can be decomposed into chunks. In
the common case of string-type keys, the chunks may be individual
characters or words, while for integer-type keys, the chunks may be
bytes.

Each entry in a trie is associated with a key and an optional value,
plus a list of sub-tries. The key of a value stored in a particular
entry is given by the path of chunks leading to it. In this way,
prefixes common to multiple keys are not duplicated but shared,
leading to reduced space usage.

A trie may be represented in Haskell by the following data type:

```haskell
data Trie k v = Trie
  { value :: (Maybe v)
  , children :: [(k, Trie k v)]
  }
```

Note the use of a list to hold sub-tries: this will have to be
traversed linearly when attempting to match the next chuck. A more
suitable data structure would be a Map, with logarithmic-time
lookup. We'll continue to use lists for simplicity.

Insertion is defined recursively, traversing the list of keys and
updating the present or newly-created entry:

```haskell
emptyTrie :: Trie k v
emptyTrie
  = Trie Nothing []

insert
  :: Eq k
  => [k]
  -> v
  -> Trie k v
  -> Trie k v
insert [] v Trie {..}
  = Trie (return v) children
insert (key : keys) v Trie {..}
  = Trie value children'
  where
    subTrie
      = fromMaybe emptyTrie $ lookup key children
    children'
      = (key, insert keys v subTrie) : filter ((/= key) . fst) children
```

Retrieval is conveniently defined in terms of a primitive which walks
the trie:

```haskell
walkTrie
  :: Eq k
  => [k]
  -> Trie k v
  -> Maybe (Trie k v)
walkTrie [] trie
  = return trie
walkTrie (key : keys) Trie {..}
  = lookup key children >>= walkTrie keys

trieLookup
  :: Eq k
  => [k]
  -> Trie k v
  -> Maybe v
trieLookup keys 
  = walkTrie keys >=> value
```

## Patricia Tries

The greater the number of chunks per key, the greater the likelihood
of a 'sparse' trie, with many single-descendent entries. An
optimisation to the above structure involves collapsing such entries
into a single one, further reducing the required space. Of course,
insertion becomes more complicated, because an entry may need to be
split if only a portion of the prefix is shared. This formulation is
commonly called a *patricia trie*.

