let raindrop n =
  match (n mod 3, n mod 5, n mod 7) with
  | 0, 0, 0 -> "PlingPlangPlong"

  | _, 0, 0 -> "PlangPlong"
  | 0, _, 0 -> "PlingPlong"
  | 0, 0, _ -> "PlingPlang"

  | 0, _, _ -> "Pling"
  | _, 0, _ -> "Plang"
  | _, _, 0 -> "Plong"

  | _, _, _ -> string_of_int n
