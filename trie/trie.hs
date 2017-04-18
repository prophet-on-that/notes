{-# LANGUAGE RecordWildCards #-}

import Data.Maybe
import Data.Foldable
import Control.Monad

data Trie k v = Trie
  { value :: (Maybe v)
  , children :: [(k, Trie k v)]
  } deriving (Show)

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

buildTrie
  :: Eq k
  => [([k], v)]
  -> Trie k v
buildTrie
  = foldl' (\trie (k, v) -> insert k v trie) emptyTrie

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

trie
  = buildTrie [ ("p", "the 16th letter of the English alphabet")
              , ("pea", "the small sperical seed or the seed-pod of the pod fruit Pisum sativum")
              , ("peanut", "a plant species in the legume family")
              , ("peanuts", "plural of peanut; syndicated comic strip started in 1950")
              , ("peanut butter", "a creamy delight commonly used in sandwiches")
              , ("on", "activated; not off")
              , ("one", "the English name for the numeral 1")
              , ("ones", "plural of 'one'")
              , ("once", "one time, and one time only")
              ]
