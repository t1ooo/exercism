module Bob (responseFor) where

import Data.Char (isSpace, toLower, toUpper)
import Data.List (isSuffixOf)

responseFor :: String -> String
responseFor xs
  | empty = "Fine. Be that way!"
  | yell && question = "Calm down, I know what I'm doing!"
  | question = "Sure."
  | yell = "Whoa, chill out!"
  | otherwise = "Whatever."
  where
    xs' = normalize xs
    empty = isEmpty xs'
    yell = isYell xs'
    question = isQuestion xs'

normalize :: String -> String
normalize xs = filter (not . isSpace) xs

isYell :: String -> Bool
isYell xs = (map toUpper xs) == xs && (map toLower xs) /= xs

isQuestion :: String -> Bool
isQuestion xs = "?" `isSuffixOf` xs

isEmpty :: String -> Bool
isEmpty xs = xs == ""
