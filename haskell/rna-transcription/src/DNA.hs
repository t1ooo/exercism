module DNA (toRNA) where

toRNA :: String -> Either Char String
toRNA xs = mapM toNucleotide xs

toNucleotide :: Char -> Either Char Char
toNucleotide 'G' = Right 'C'
toNucleotide 'C' = Right 'G'
toNucleotide 'T' = Right 'A'
toNucleotide 'A' = Right 'U'
toNucleotide n = Left n
