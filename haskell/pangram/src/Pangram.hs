module Pangram (isPangram) where

import Data.Char (toLower)

isPangram :: String -> Bool
isPangram text = all (`elem` normalize text) ['a' .. 'z']

normalize :: String -> String
normalize text = map toLower text