#[derive(Debug, PartialEq)]
pub enum Error {
    IncompleteNumber,
    Overflow,
}

/// Convert a list of numbers to a stream of bytes encoded with variable length encoding.
pub fn to_bytes(values: &[u32]) -> Vec<u8> {
    values
        .iter()
        .flat_map(|&x| encode(x as u64))
        .map(|x| x as u8)
        .collect()
}

/// Given a stream of bytes, extract all numbers which are encoded in there.
pub fn from_bytes(bytes: &[u8]) -> Result<Vec<u32>, Error> {
    let dec = decode(bytes);
    if dec.is_empty() {
        return Err(Error::IncompleteNumber);
    }
    if dec.iter().any(|&x| x > u32::MAX as u64) {
        return Err(Error::Overflow);
    }
    Ok(dec.iter().map(|&x| x as u32).collect())
}

fn encode(num: u64) -> Vec<u64> {
    let len = 7;
    let bits = dec_to_base(num, 2);
    let splited = split(bits, len);
    let padded = splited.iter().map(|x| pad_slice(x, 0, len)).collect();
    let prepended = prepend(padded);
    prepended.iter().map(|x| bits_to_num(x)).rev().collect()
}

fn decode(encoded_nums: &[u8]) -> Vec<u64> {
    let len = 8;
    let mut res = vec![];
    let mut buf = vec![];
    for &e_num in encoded_nums.iter() {
        let bits = dec_to_base(e_num as u64, 2);
        let padded = pad_slice(&bits, 0, len);
        let last = padded[0] == 0;
        buf.push(padded);
        if last {
            let n = buf
                .iter()
                .flat_map(|x| x[1..].to_vec())
                .collect::<Vec<u64>>();
            res.push(bits_to_num(&n));
            buf.clear();
        }
    }
    res
}

fn dec_to_base(mut num: u64, base: u64) -> Vec<u64> {
    let mut res = vec![];
    loop {
        let rem = num % base;
        num /= base;
        res.push(rem);
        if num == 0 {
            break;
        }
    }
    reverse(&res)
}

fn split(bits: Vec<u64>, len: usize) -> Vec<Vec<u64>> {
    reverse(&bits).chunks(len).map(reverse).collect()
}

fn prepend(split: Vec<Vec<u64>>) -> Vec<Vec<u64>> {
    split
        .iter()
        .enumerate()
        .map(|(i, v)| {
            let pad = if i == 0 { 0 } else { 1 };
            pad_slice(v, pad, v.len() + 1)
        })
        .collect()
}

fn reverse<T: Clone>(s: &[T]) -> Vec<T> {
    s.iter().rev().cloned().collect()
}

fn pad_slice(s: &[u64], value: u64, len: usize) -> Vec<u64> {
    let mut pad = vec![value; len - s.len()];
    pad.extend(s.iter().cloned());
    pad
}

fn bits_to_num(bits: &[u64]) -> u64 {
    let s = bits
        .iter()
        .map(|x| x.to_string())
        .collect::<Vec<String>>()
        .join("");
    u64::from_str_radix(&s, 2).unwrap()
}
