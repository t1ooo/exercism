#![feature(generators, generator_trait)]

use std::collections::HashMap;
use std::ops::{Generator, GeneratorState};
use std::pin::Pin;

type VecChar = Vec<char>;
type VecU8 = Vec<u8>;

pub fn solve(input: &str) -> Option<HashMap<char, u8>> {
    let args = parse_expr(input);
    let firsts = args.iter().map(|x| x[0]).collect::<VecChar>();
    if let Some(res) = psolve(args, Dict::new(), 0, &firsts) {
        return Some(res.to_dict());
    }
    None
}

fn psolve(mut args: Vec<VecChar>, dict: Dict, carry: u8, firsts: &[char]) -> Option<Dict> {
    let col = next_col(&mut args);
    if col.is_empty() {
        return Some(dict);
    }

    let col_filtered = uniq(col.iter().filter(|x| !dict.has(**x)).cloned().collect());
    if col_filtered.is_empty() {
        let digits = dict.values_by_keys(&col);
        if let Some(next_carry) = evaluate(digits, carry) {
            return psolve(args, dict, next_carry, firsts);
        }
        return None;
    }

    let exclude_digits = dict.values();
    let candidates = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        .iter()
        .filter(|&x| !exclude_digits.contains(x))
        .copied()
        .collect::<VecU8>();

    let check_firsts = candidates.iter().any(|&x| x == 0);

    let mut perms = permutation(candidates, col_filtered.len());

    while let GeneratorState::Yielded(perm) = Pin::new(&mut perms).resume(()) {
        if check_firsts
            && col_filtered
                .iter()
                .zip(perm.iter())
                .any(|(ch, digit)| *digit == 0 && firsts.contains(ch))
        {
            continue;
        }

        let updated_dict = dict.extended(&col_filtered, &perm);

        let digits = updated_dict.values_by_keys(&col);
        if let Some(next_carry) = evaluate(digits, carry) {
            let res = psolve(args.to_vec(), updated_dict, next_carry, firsts);
            if res.is_some() {
                return res;
            }
        }
    }
    None
}

fn evaluate(digits: VecU8, carry: u8) -> Option<u8> {
    let sum = (carry as usize)
        + digits[0..digits.len() - 1]
            .iter()
            .map(|&x| x as usize)
            .sum::<usize>();
    let res = digits[digits.len() - 1] as usize;
    if sum % 10 == res {
        let next_carry = (sum / 10) as u8;
        return Some(next_carry);
    }
    None
}

fn next_col(args: &mut Vec<VecChar>) -> VecChar {
    let mut col = vec![];
    for arg in args.iter_mut() {
        if let Some(v) = arg.pop() {
            col.push(v);
        }
    }
    col
}

pub fn parse_expr(expr: &str) -> Vec<VecChar> {
    expr.split("==")
        .flat_map(|x| {
            x.split('+')
                .map(|x| x.trim().chars().collect::<VecChar>())
                .collect::<Vec<VecChar>>()
        })
        .collect()
}

fn uniq<T: Ord>(mut vec: Vec<T>) -> Vec<T> {
    vec.sort_unstable();
    vec.dedup();
    vec
}

pub fn permutation(
    s_arr: VecU8,
    s_limit: usize,
) -> impl Generator<Yield = VecU8, Return = ()> {
    move || {
        yield s_arr[0..s_limit].to_vec();
        let mut stack = vec![(s_arr, 0, s_limit)];
        while let Some((arr, swap_i, limit)) = stack.pop() {
            if arr.len() <= swap_i + 1 {
                continue;
            }
            if limit == 0 {
                continue;
            }
            for i in swap_i + 1..arr.len() {
                let mut copy = arr.to_vec();
                copy.swap(i, swap_i);
                yield copy[0..s_limit].to_vec();
                stack.push((copy, swap_i + 1, limit - 1));
            }
            stack.push((arr, swap_i + 1, limit - 1));
        }
    }
}

// -------------------------------

#[derive(Clone, Copy)]
struct Dict {
    data: [Option<u8>; 26],
}

impl Dict {
    fn new() -> Self {
        Self { data: [None; 26] }
    }
    fn extended(&self, keys: &[char], values: &[u8]) -> Self {
        let mut dict = *self;
        keys.iter()
            .zip(values.iter())
            .for_each(|(&ch, &digit)| dict.set(ch, digit));
        dict
    }
    fn has(&self, ch: char) -> bool {
        self.data[char_to_index(ch)].is_some()
    }
    fn get(&self, ch: char) -> Option<u8> {
        self.data[char_to_index(ch)]
    }
    fn set(&mut self, ch: char, value: u8) {
        self.data[char_to_index(ch)] = Some(value)
    }
    fn values(&self) -> VecU8 {
        self.data.iter().filter_map(|&x| x).collect()
    }
    fn values_by_keys(&self, keys: &[char]) -> VecU8 {
        keys.iter().map(|&x| self.get(x).unwrap()).collect()
    }
    fn to_dict(&self) -> HashMap<char, u8> {
        self.data
            .iter()
            .enumerate()
            .filter(|(_, v)| v.is_some())
            .map(|(i, v)| (index_to_char(i), v.unwrap()))
            .collect()
    }
}

fn char_to_index(ch: char) -> usize {
    valid_char_or_panic(ch);
    (ch as usize) - ('A' as usize)
}

fn index_to_char(index: usize) -> char {
    let ch = ((index as u8) + b'A') as char;
    valid_char_or_panic(ch);
    ch
}

fn valid_char_or_panic(ch: char) {
    if ch < 'A' || 'Z' < ch {
        panic!("char is not valid")
    }
}
