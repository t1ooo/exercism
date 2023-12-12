#![feature(test)]

extern crate test;

use test::Bencher;
use sublist::{sublist};

#[bench]
fn bench_superlist_early_in_huge_list(b: &mut Bencher) {
    let huge: Vec<u32> = (1..1_000_000).collect();
    b.iter(|| sublist(&huge, &[3, 4, 5]))
}