module POV (fromPOV, tracePathBetween) where

import Data.List (delete)
import Data.Tree (Tree (Node), rootLabel)

fromPOV :: Eq a => a -> Tree a -> Maybe (Tree a)
fromPOV x tree =
  traceNodePath x tree
    >>= inversePath

tracePathBetween :: Eq a => a -> a -> Tree a -> Maybe [a]
tracePathBetween from to tree =
  fromPOV from tree
    >>= traceNodePath to
    >>= Just . map rootLabel

traceNodePath :: Eq a => a -> Tree a -> Maybe [Tree a]
traceNodePath to tree =
  case traceNodePath' to tree [] of
    [] -> Nothing
    x -> Just x

traceNodePath' :: Eq a => a -> Tree a -> [Tree a] -> [Tree a]
traceNodePath' to node@(Node v childs) acc =
  if to == v
    then reverse (node : acc)
    else concatMap (\child -> traceNodePath' to child (node : acc)) childs

inversePath :: Eq a => [Tree a] -> Maybe (Tree a)
inversePath [] = Nothing
inversePath path = Just $ foldl1 (\parent child -> snd $ inverse parent child) path

inverse :: Eq a => Tree a -> Tree a -> (Tree a, Tree a)
inverse parent child =
  let parent' = deleteNode child parent
      child' = insertNode parent' child
   in (parent', child')

insertNode :: Tree a -> Tree a -> Tree a
insertNode node (Node v childs) = Node v (node : childs)

deleteNode :: Eq a => Tree a -> Tree a -> Tree a
deleteNode node (Node v childs) = Node v (delete node childs)
