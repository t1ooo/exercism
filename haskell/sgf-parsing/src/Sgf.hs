module Sgf (parseSgf) where

import Data.Map (Map, fromList)
import Data.Tree (Tree (Node))
import Text.Parsec (Parsec, anyChar, char, letter, many, many1, oneOf, optionMaybe, parse, string, upper)
import Text.Parsec.Prim ((<|>))

-- parser --

parseSgf :: String -> Maybe SgfTree
parseSgf sgf = eitherToMaybe $ parse parser "" sgf

parser :: Parsec String () SgfTree
parser = do
  char '('
  nodes <- many1 properties
  nested <- optionMaybe $ many parser
  char ')'
  let tree = fromNodes nodes
  case nested of
    Nothing -> return tree
    Just v -> return (insertAll v tree)

properties :: Parsec String () SgfNode
properties = do
  char ';'
  r <- many property
  return $ fromList r

property :: Parsec String () (String, [String])
property = do
  key <- upper
  values <- many1 value
  return ([key], values)

value :: Parsec String () String
value = do
  char '['
  r <- many (escapedChar <|> letter <|> space)
  char ']'
  return $ removeSpaces r

escapedChar :: Parsec String () Char
escapedChar = do
  string "\\"
  r <- anyChar
  return r

space :: Parsec String () Char
space = do
  oneOf "\n\t "
  return ' '

-- SgfNode --

type SgfTree = Tree SgfNode

type SgfNode = Map String [String]

singleton :: SgfNode -> SgfTree
singleton x = Node x []

fromNodes :: [SgfNode] -> SgfTree
fromNodes x = foldl1 (\acc x -> insert x acc) (map singleton x)

insert :: SgfTree -> SgfTree -> SgfTree
insert node (Node v childs) = Node v (node : childs)

insertAll :: [SgfTree] -> SgfTree -> SgfTree
insertAll nodes (Node v childs) = Node v (nodes ++ childs)

-- utils --

eitherToMaybe :: Either l r -> Maybe r
eitherToMaybe e = case e of
  Right r -> Just r
  Left _ -> Nothing

removeSpaces :: String -> String
removeSpaces s = filter (\x -> notElem x "\n\t") s
