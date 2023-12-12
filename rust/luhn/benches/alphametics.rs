#![feature(test)]

extern crate test;

use test::Bencher;

#[bench]
fn bench_solve(b: &mut Bencher) {
    b.iter(|| luhn::is_valid("234 567 891 234"));
}