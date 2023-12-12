module Series (Error (..), largestProduct) where

import Data.Char (digitToInt, isDigit)

data Error = InvalidSpan | InvalidDigit Char deriving (Show, Eq)

largestProduct :: Int -> String -> Either Error Integer
largestProduct size digits
  | size < 0 = Left InvalidSpan
  | length digits < size = Left InvalidSpan
  | otherwise = (mapM charToInt digits) >>= (Right . largestProd size)

largestProd :: Int -> [Int] -> Integer
largestProd 0 _ = 1
largestProd size nums = fromIntegral $ maximum products
  where
    series = groupN size nums []
    products = (map product series)

charToInt :: Char -> Either Error Int
charToInt x
  | isDigit x = Right $ digitToInt x
  | otherwise = Left $ InvalidDigit x

groupN :: Int -> [a] -> [[a]] -> [[a]]
groupN _ [] _ = []
groupN size l@(_ : xs) acc
  | length l <= size = reverse (l : acc)
  | otherwise = groupN size xs (take size l : acc)
