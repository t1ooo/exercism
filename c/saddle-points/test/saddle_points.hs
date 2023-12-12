import Data.List (transpose, intersect,findIndices)

m = [[9,  8,  7],
     [5,  3,  2],
     [6,  6,  7]]
-- f m = 
--     let max_in_rows = map maximum m
--         min_in_cols = map minimum (transpose m)
--         vals = intersect max_in_rows min_in_cols
--         in concat $ map 
--             ( \(row, r) -> 
--                     filter (/=(0,0)) $
--                     map 
--                     (\(v, c) -> if v `elem` vals then (r+1,c+1) else (0,0)) 
--                     (zip row [0..]) 
--             ) 
--             (zip m [0..])
f m = 
    let max_in_rows = map maximum m
        min_in_cols = map minimum (transpose m)
    in 
        map (\(x,y) ->(x+1,y+1)) $ concat (
            map 
            -- (\(i, r) -> (i,findIndices (==r) min_in_cols)) 
            (\(i, r) -> zip [i,i..] $ findIndices (==r) min_in_cols) 
            (zip [0.. ] max_in_rows)
        )
