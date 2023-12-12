module Counting
  ( Color (..),
    territories,
    territoryFor,
  )
where

import Data.List (find, sort)
import qualified Data.Set as S (Set, fromList, toList)

data Color = Black | White deriving (Eq, Ord, Show)
type MColor = Maybe Color
type Coord = (Int, Int)
type Ceil = (Coord, Char)

territories :: [String] -> [(S.Set Coord, MColor)]
territories board =
  foldl f [] (detectOwners $ findAreas board)
  where
    f acc (coords, color) = (coords', color) : acc
      where
        coords' = S.fromList (map (incr . ceilToCoord) $ filter isEmptyCeil coords)
        ceilToCoord (coord, _) = coord
        incr coord = add coord (1, 1)

territoryFor :: [String] -> Coord -> Maybe (S.Set Coord, MColor)
territoryFor board (x, y) = find (\(coords, _) -> elem (x, y) coords) (territories board)

nthnth :: [[a]] -> Int -> Int -> Maybe a
nthnth m y x = nth m y >>= (`nth` x)
  where
    nth [] _ = Nothing
    nth (x' : _) 0 = Just x'
    nth (_ : xs) i = nth xs (i -1)

add :: Coord -> Coord -> Coord
add (x, y) (x', y') = (x + x', y + y')

findArea :: [String] -> Coord -> [Coord] -> [Ceil]
findArea board (x, y) visited =
  case nthnth board y x of
    Just 'B' -> [((x, y), 'B')]
    Just 'W' -> [((x, y), 'W')]
    Just ' ' -> ((x, y), ' ') : nexts
    Nothing -> []
    _ -> error "undefined char"
  where
    visited' = (x, y) : visited
    neighbors = [add (x, y) diff | diff <- [(1, 0), (-1, 0), (0, 1), (0, -1)]]
    neighbors' = filter (`notElem` visited) neighbors
    nexts = concatMap (\coord -> findArea board coord visited') neighbors'

findAreas :: [String] -> [[Ceil]]
findAreas board =
  uniq (filter isAnyEmpty $ map findArea' coords)
  where
    coords = [(x, y) | line <- board, y <- range board, x <- range line]
    range xs = [0 .. (length xs - 1)]
    isAnyEmpty xs = any isEmptyCeil xs
    findArea' coord = findArea board coord []
    uniq xs = S.toList (S.fromList $ map sort xs)

detectOwners :: [[Ceil]] -> [([Ceil], MColor)]
detectOwners xs = map (\x -> (x, detectOwner x)) xs

detectOwner :: [Ceil] -> MColor
detectOwner xs
  | isAnyBlack && isAnyWhite = Nothing
  | isAnyBlack = Just Black
  | isAnyWhite = Just White
  | otherwise = Nothing
  where
    isAnyBlack = any isBlackCeil xs
    isAnyWhite = any isWhiteCeil xs

isBlackCeil (_, color) = color == 'B'
isWhiteCeil (_, color) = color == 'W'
isEmptyCeil (_, color) = color == ' '