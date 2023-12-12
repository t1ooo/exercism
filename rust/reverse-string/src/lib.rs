pub fn reverse(input: &str) -> String {
    let mut buf = Vec::new();
    for v in input.encode_utf16() {
        if is_grapheme(v) {
            let tmp = buf.pop().unwrap();
            buf.push(v);
            buf.push(tmp);
        } else {
            buf.push(v);
        }
    }
    buf.reverse();
    String::from_utf16(&buf).unwrap()
}

// https://www.ncbi.nlm.nih.gov/staff/beck/charents/accents.html
fn is_grapheme(c: u16) -> bool {
    (0x0300<=c && c<=0x034E) ||
    (0x0360<=c && c<=0x0362) ||
    (0x20D0<=c && c<=0x20E3)
}
