let leap_year year =
  let f x = year mod x = 0 
  in
  f 4 && (not (f 100) || f 400)
