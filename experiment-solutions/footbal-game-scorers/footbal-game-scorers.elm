module AggregateScorers exposing (..)

aggregateScorers : List String -> List String
aggregateScorers playerNames =
    List.map 
        (\name -> format name (count playerNames name)) 
        (List.sort (unique playerNames))
    
unique lst =
    List.foldl (\v acc -> if List.member v acc then acc else v :: acc) [] lst

count lst value = 
    List.foldl (\v acc -> if v == value then acc+1 else acc+0) 0 lst

format name score =
    case score of
        1 -> name
        _ -> name ++" (" ++ Debug.toString(score) ++ ")"
