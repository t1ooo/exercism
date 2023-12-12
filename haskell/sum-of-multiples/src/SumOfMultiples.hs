module SumOfMultiples (sumOfMultiples) where

import Data.Set (fromAscList)

sumOfMultiples :: [Integer] -> Integer -> Integer
sumOfMultiples factors limit =
  sum $ foldMap f factors'
  where
    f factor = fromAscList [0, factor .. limit -1]
    factors' = filter (/= 0) factors
