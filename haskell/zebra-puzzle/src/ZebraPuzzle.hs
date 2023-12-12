module ZebraPuzzle (Resident (..), Solution (..), solve) where

import Control.Monad (guard)
import Data.List (permutations, zipWith5)

data Resident = Englishman | Spaniard | Ukrainian | Norwegian | Japanese
  deriving (Eq, Show, Enum, Bounded)

data Pet = Dog | Snails | Fox | Horse | Zebra
  deriving (Eq, Show, Enum, Bounded)

data Beverage = Cofee | Tea | Milk | OrangeJuice | Water
  deriving (Eq, Show, Enum, Bounded)

data Cigarette = OldGold | Kools | Chesterfields | LuckyStrike | Parliaments
  deriving (Eq, Show, Enum, Bounded)

data Color = Red | Green | Ivory | Yellow | Blue
  deriving (Eq, Show, Enum, Bounded)

data House = House
  { resident :: Resident,
    pet :: Pet,
    beverage :: Beverage,
    cigarette :: Cigarette,
    color :: Color
  }
  deriving (Eq, Show)

data Solution = Solution {waterDrinker :: Resident, zebraOwner :: Resident}
  deriving (Eq, Show)

solve :: Solution
solve = Solution drinker owner
  where
    result = solve'
    extract f list = resident . head $ filter f list
    drinker = extract (\h -> beverage h == Water) result
    owner = extract (\h -> pet h == Zebra) result

solve' :: [House]
solve' = do
  residents <- permutations [minBound :: Resident ..]
  -- 10. The Norwegian lives in the first house.
  guard $ head residents == Norwegian

  colors <- permutations [minBound :: Color ..]
  -- 6.  The green house is immediately to the right of the ivory house.
  guard $ rightOf (Ivory, Green) (colors, colors)

  -- 2.  The Englishman lives in the red house.
  guard $ elemOf (Englishman, Red) (residents, colors)

  -- 15. The Norwegian lives next to the blue house.
  guard $ nextTo (Norwegian, Blue) (residents, colors)

  beverages <- permutations [minBound :: Beverage ..]
  -- 9.  Milk is drunk in the middle house.
  guard $ beverages !! 2 == Milk

  -- 4.  Coffee is drunk in the green house.
  guard $ elemOf (Cofee, Green) (beverages, colors)

  -- 5.  The Ukrainian drinks tea.
  guard $ elemOf (Ukrainian, Tea) (residents, beverages)

  cigarettes <- permutations [minBound :: Cigarette ..]
  -- 8.  Kools are smoked in the yellow house.
  guard $ elemOf (Kools, Yellow) (cigarettes, colors)

  -- 13. The Lucky Strike smoker drinks orange juice.
  guard $ elemOf (LuckyStrike, OrangeJuice) (cigarettes, beverages)

  -- 14. The Japanese smokes Parliaments.
  guard $ elemOf (Japanese, Parliaments) (residents, cigarettes)

  pets <- permutations [minBound :: Pet ..]
  -- 3.  The Spaniard owns the dog.
  guard $ elemOf (Spaniard, Dog) (residents, pets)

  -- 7.  The Old Gold smoker owns snails.
  guard $ elemOf (OldGold, Snails) (cigarettes, pets)

  -- 11. The man who smokes Chesterfields lives in the house next to the man with the fox.
  guard $ nextTo (Chesterfields, Fox) (cigarettes, pets)

  -- 12. Kools are smoked in the house next to the house where the horse is kept.
  guard $ nextTo (Kools, Horse) (cigarettes, pets)

  zipWith5 House residents pets beverages cigarettes colors
  where
    elemOf v (xs, ys) = v `elem` zip xs ys
    rightOf (x, y) (xs, ys) = elem (x, y) $ zip xs (tail ys)
    nextTo (x, y) (xs, ys) = rightOf (x, y) (xs, ys) || rightOf (y, x) (ys, xs)