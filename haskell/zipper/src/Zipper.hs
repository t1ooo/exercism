module Zipper
  ( BinTree (BT),
    fromTree,
    left,
    right,
    setLeft,
    setRight,
    setValue,
    toTree,
    up,
    value,
  )
where

data BinTree a = BT
  { btValue :: a,
    btLeft :: Maybe (BinTree a),
    btRight :: Maybe (BinTree a)
  }
  deriving (Eq, Show)

data Direction = LF | RG deriving (Eq, Show)

data Zipper a = Z
  { zFocus :: (BinTree a),
    zRest :: [(a, Direction, Maybe (BinTree a))]
  }
  deriving (Eq, Show)

fromTree :: BinTree a -> Zipper a
fromTree tree = Z tree []

toTree :: Zipper a -> BinTree a
toTree z = zFocus $ top z

top :: Zipper a -> Zipper a
top z = case up z of
  Nothing -> z
  Just z' -> top z'

value :: Zipper a -> a
value (Z (BT v _ _) _) = v

left :: Zipper a -> Maybe (Zipper a)
left (Z (BT v l r) rest) = case l of
  Nothing -> Nothing
  Just l' -> Just $ Z l' ((v, LF, r) : rest)

right :: Zipper a -> Maybe (Zipper a)
right (Z (BT v l r) rest) = case r of
  Nothing -> Nothing
  Just r' -> Just $ Z r' ((v, RG, l) : rest)

up :: Zipper a -> Maybe (Zipper a)
up (Z _ []) = Nothing
up (Z focus ((v, direction, tree) : rest)) = Just $ Z (f direction) rest
  where
    f LF = BT v (Just focus) tree
    f RG = BT v tree (Just focus)

setValue :: a -> Zipper a -> Zipper a
setValue v (Z (BT _ l r) rest) = Z (BT v l r) rest

setLeft :: Maybe (BinTree a) -> Zipper a -> Zipper a
setLeft tree (Z (BT v _ r) rest) = (Z (BT v tree r) rest)

setRight :: Maybe (BinTree a) -> Zipper a -> Zipper a
setRight tree (Z (BT v l _) rest) = (Z (BT v l tree) rest)
