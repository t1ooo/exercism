module DND
  ( Character (..),
    ability,
    modifier,
    character,
  )
where

import Control.Monad (replicateM)
import Data.List (delete)
import Test.QuickCheck (Gen, choose)

data Character = Character
  { strength :: Int,
    dexterity :: Int,
    constitution :: Int,
    intelligence :: Int,
    wisdom :: Int,
    charisma :: Int,
    hitpoints :: Int
  }
  deriving (Show, Eq)

modifier :: Int -> Int
modifier n = (n - 10) `div` 2

ability :: Gen Int
ability = do
  rolls <- replicateM 4 (choose (1, 6))
  return $ sum (delete (minimum rolls) rolls)

character :: Gen Character
character = do
  constitution' <- ability
  Character
    <$> ability
    <*> ability
    <*> (pure constitution')
    <*> ability
    <*> ability
    <*> ability
    <*> pure (10 + modifier constitution')
