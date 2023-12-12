pub fn annotate(minefield: &[&str]) -> Vec<String> {
    minefield
        .iter()
        .enumerate()
        .map(|(y, row)| {
            row.chars()
                .enumerate()
                .map(|(x, v)| match v {
                    ' ' => format(count_mines(minefield, x, y)),
                    v => v,
                })
                .collect::<String>()
        })
        .collect::<Vec<String>>()
}

fn count_mines(minefield: &[&str], x: usize, y: usize) -> usize {
    neighbors(x, y, minefield)
        .iter()
        .filter(|&&ch| ch == '*')
        .count()
}

fn format(num: usize) -> char {
    match num {
        0 => ' ',
        _ => digit_to_char(num),
    }
}

fn digit_to_char(digit: usize) -> char {
    if 9 < digit {
        panic!("not digit");
    }
    digit.to_string().chars().next().unwrap()
}

fn neighbors(mx: usize, my: usize, minefield: &[&str]) -> Vec<char> {
    let range = |v: usize| v.saturating_sub(1)..=(v + 1); // [v-1,v+1]
    range(my)
        .filter_map(|y| minefield.get(y))
        .flat_map(|line| range(mx).filter_map(move |x| line.chars().nth(x)))
        .collect::<Vec<char>>()
}
