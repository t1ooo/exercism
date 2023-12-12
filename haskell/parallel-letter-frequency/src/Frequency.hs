module Frequency (frequency) where

import Control.DeepSeq (NFData)
import Control.Parallel.Strategies (parMap, rdeepseq)
import Data.Char (isLetter, toLower)
import qualified Data.Map as M (Map, empty, insertWith, unionsWith)
import qualified Data.Text as T (Text, filter, foldl')

frequency :: Int -> [T.Text] -> M.Map Char Int
frequency nWorkers texts
  | nWorkers <= 0 = error "nWorkers <= 0"
  | nWorkers == 1 = frequencySync texts
  | otherwise = frequencyParallel nWorkers texts

frequencyParallel :: Int -> [T.Text] -> M.Map Char Int
frequencyParallel nWorkers texts =
  M.unionsWith (+) $ pmap frequencySync (splitToN nWorkers texts)

pmap :: NFData b => (a -> b) -> [a] -> [b]
pmap f xs = parMap rdeepseq f xs

frequencySync :: [T.Text] -> M.Map Char Int
frequencySync texts =
  M.unionsWith (+) $ map frequencyText texts

frequencyText :: T.Text -> M.Map Char Int
frequencyText text =
  T.foldl' f M.empty $ T.filter isLetter text
  where
    updateCounter k m = M.insertWith (+) k 1 m
    f acc' ch = updateCounter (toLower ch) acc'

splitToN :: Int -> [a] -> [[a]]
splitToN n xs
  | n <= 0 = error "n <= 0"
  | otherwise = split xs
  where
    toFloat x = fromIntegral x :: Float
    chunkLen = ceiling $ (toFloat $ length xs) / (toFloat n)
    split [] = []
    split x = (take chunkLen x) : split (drop chunkLen x)
