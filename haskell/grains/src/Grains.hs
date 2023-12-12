module Grains (square, total) where

square :: Integer -> Maybe Integer
square n
  | n < 1 || 64 < n = Nothing
  | otherwise = Just $ 2 ^ (n - 1)

total :: Integer
total = sum $ map (2 ^) ([0 .. 64 - 1] :: [Integer])
