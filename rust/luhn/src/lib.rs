/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool {
    let mut sum = 0;
    let mut i = 0;
    for ch in code.chars().rev() {
        match ch.to_digit(10) {
            Some(digit) => {
                sum += if i % 2 == 0 {
                    digit
                } else if 4 < digit {
                    digit * 2 - 9
                } else {
                    digit * 2
                };
                i+=1;
            },
            None => {
                if ch != ' ' {
                    break
                }
            },
        }
    }
    i > 1 && sum % 10 == 0
}
