module CollatzConjecture (collatz) where

collatz :: Integer -> Maybe Integer
collatz n
  | n <= 0 = Nothing
  | otherwise = Just (collatz' n 0)

collatz' :: Integer -> Integer -> Integer
collatz' n acc
  | n == 1 = acc
  | otherwise = collatz' (next n) (acc + 1)

next :: Integer -> Integer
next n
  | even n = n `div` 2
  | otherwise = 3 * n + 1