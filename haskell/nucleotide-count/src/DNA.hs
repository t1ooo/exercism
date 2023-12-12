module DNA (nucleotideCounts, Nucleotide (..)) where

import Control.Monad (foldM)
import Data.Map (Map, adjust, fromList)

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts xs =
  foldM f initCounts xs
  where
    incr k m = adjust (1 +) k m
    f counts char = fmap (`incr` counts) (nucleotide char)
    initCounts = fromList [(A, 0), (C, 0), (G, 0), (T, 0)]

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

nucleotide :: Char -> Either String Nucleotide
nucleotide 'A' = Right A
nucleotide 'C' = Right C
nucleotide 'G' = Right G
nucleotide 'T' = Right T
nucleotide _ = Left "bad nucleotide"