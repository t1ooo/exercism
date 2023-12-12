pub fn get_diamond(c: char) -> Vec<String> {
    let range = || 'A'..=c;
    let str_len = (range().count() * 2) - 1;

    let tail: Vec<String> = range()
        .rev()
        .enumerate()
        .map(|(i, ch)| {
            let mut v = vec![' '; str_len];
            v[i] = ch;
            v[str_len - 1 - i] = ch;
            v.iter().collect()
        })
        .collect();

    let head = tail.iter().skip(1).rev();

    head.chain(tail.iter()).cloned().collect()
}
