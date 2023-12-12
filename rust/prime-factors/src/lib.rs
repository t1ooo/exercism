// Trial division
pub fn factors(n: u64) -> Vec<u64> {
    let mut i = 2;
    let mut num = n;
    let mut res: Vec<u64> = vec!();
    while num > 1 {
        while num % i == 0 {
            num /= i;
            res.push(i);
        }
        i+=1;
    }
    res
}