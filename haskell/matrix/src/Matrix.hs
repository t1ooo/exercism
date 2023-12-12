module Matrix
  ( Matrix,
    cols,
    column,
    flatten,
    fromList,
    fromString,
    reshape,
    row,
    rows,
    shape,
    transpose,
  )
where

import qualified Data.Vector as V

data Matrix a = Matrix
  { mRowN :: Int,
    mColN :: Int,
    mVec :: V.Vector a
  }
  deriving (Eq, Show)

cols :: Matrix a -> Int
cols (Matrix _ colN _) = colN

column :: Int -> Matrix a -> V.Vector a
column x (Matrix rowN colN vec) =
  V.backpermute vec (V.enumFromStepN (x -1) colN rowN)

flatten :: Matrix a -> V.Vector a
flatten (Matrix _ _ vec) = vec

fromList :: [[a]] -> Matrix a
fromList [] = Matrix 0 0 V.empty
fromList xss = Matrix (length xss) (length $ head xss) (V.fromList $ concat xss)

fromString :: Read a => String -> Matrix a
fromString xs = fromList $ map fromLine (lines xs)
  where
    fromLine line = map read (words line)

reshape :: (Int, Int) -> Matrix a -> Matrix a
reshape (rowN, colN) (Matrix _ _ vec) = Matrix rowN colN vec

row :: Int -> Matrix a -> V.Vector a
row x (Matrix _ colN vec) =
  V.slice (index (x -1) 0 colN) colN vec

rows :: Matrix a -> Int
rows (Matrix rowN _ _) = rowN

shape :: Matrix a -> (Int, Int)
shape (Matrix rowN colN _) = (rowN, colN)

transpose :: Matrix a -> Matrix a
transpose (Matrix rowN colN vec) = (Matrix colN rowN vec2)
  where
    vec2 = V.generate (rowN * colN) gen
    gen i =
      let (ro, co) = unindex i rowN
          idx = index co ro colN
       in vec V.! idx

---------------------------------

index :: Int -> Int -> Int -> Int
index ro co colN = co + (colN * ro)

-- return (ro, co)
unindex :: Int -> Int -> (Int, Int)
unindex idx colN = quotRem idx colN
