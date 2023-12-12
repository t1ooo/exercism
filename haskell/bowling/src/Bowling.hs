module Bowling (score, BowlingError (..)) where

import Data.List (findIndex)

data BowlingError
  = IncompleteGame
  | InvalidRoll {rollIndex :: Int, rollValue :: Int}
  deriving (Eq, Show)

score :: [Int] -> Either BowlingError Int
score rolls =
  case validate rolls of
    Left e -> Left e
    Right _ -> Right $ score' rolls

score' :: [Int] -> Int
score' rolls =
  (sum rolls)
    + sum (map extraScore (init rollsTyples))
    + lastExtraScore (last rollsTyples)
  where
    rollsFrames = frames rolls 0
    first9Frames = take 9 rollsFrames
    lastFrame = take 2 (head $ drop 9 rollsFrames)
    rollsTyples = typles3 (concat $ (first9Frames ++ [lastFrame]))

    typles3 xs = zip3 xs (tail xs) (tail $ tail xs)

    extraScore (10, b, c) = b + c
    extraScore (a, b, c) = if a + b == 10 then c else 0

    lastExtraScore (10, b, c) = b + c
    lastExtraScore _ = 0

frames :: [Int] -> Int -> [[Int]]
frames [] _ = []
frames [a] _ = [[a]]
frames (a : b : rest) n
  | (n == 9) = [a : b : rest]
  | (a == 10) = [a] : frames (b : rest) (n + 1)
  | otherwise = [a, b] : frames rest (n + 1)

validate :: [Int] -> Either BowlingError ()
validate [] = Left IncompleteGame
validate rolls = do
  validatePoint
  validateRoll
  validateFirsts
  validateLast lastFrame
  where
    rollsFrames = frames rolls 0
    first9Frames = take 9 $ rollsFrames
    lastFrame = head $ drop 9 rollsFrames

    validatePoint =
      case findIndex (\x -> x < 0 || x > 10) rolls of
        Just i -> Left $ InvalidRoll i (rolls !! i)
        Nothing -> Right ()

    validateRoll =
      case findIndex (\x -> sum x > 10) first9Frames of
        Just i -> Left $ InvalidRoll (1 + i * 2) (last $ first9Frames !! i)
        Nothing -> Right ()

    validateFirsts =
      if length first9Frames < 9
        then Left IncompleteGame
        else Right ()

    validateLast [10] = Left IncompleteGame
    validateLast [a, b]
      | (a == 10 && b == 10) || (a + b == 10) = Left IncompleteGame
    validateLast (a : b : c : d : _)
      | (a == 10) || (a + b == 10) = Left $ InvalidRoll 21 c
    validateLast [10, 10, c] = Right ()
    validateLast (a : b : c : _)
      | (a == 10 && b + c > 10) || (a + b < 10) = Left $ InvalidRoll 20 c
    validateLast _ = Right ()
