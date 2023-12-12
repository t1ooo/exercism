module PhoneNumber where

import Data.List (isPrefixOf)

clean num = num5
  where
    num2 = filter (\x -> x `notElem` "() -.") num
    num3 =
      if isPrefixOf "+1" num2
        then drop 2 num2
        else num2
    num4 =
      if any (\x -> x `notElem` ['0' .. '9']) num3
        then "0000000000"
        else num3
    num5 =
      if length num4 /= (3 + 3 + 4)
        then "0000000000"
        else num4