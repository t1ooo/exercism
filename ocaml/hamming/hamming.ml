type nucleotide = A | C | G | T

let distance a b =
  List.fold_left2 (fun acc a b -> acc + if a = b then 0 else 1) 0 a b

let hamming_distance dna1 dna2 =
  match (List.length dna1, List.length dna2) with
  | len1, len2 when len1 = len2 -> Ok (distance dna1 dna2)
  | 0, _ -> Error "left strand must not be empty"
  | _, 0 -> Error "right strand must not be empty"
  | _ -> Error "left and right strands must be of equal length"
