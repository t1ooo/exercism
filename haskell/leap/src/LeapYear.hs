module LeapYear (isLeapYear) where

isLeapYear :: Integer -> Bool
isLeapYear year =
  test 4 && (not (test 100) || test 400)
  where
    test x = rem year x == 0