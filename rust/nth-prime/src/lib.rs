#[macro_use]
extern crate lazy_static;

lazy_static! {
    static ref PRIMES: Vec<usize> = primes(1_000_000);
}

pub fn nth(n: u32) -> u32 {
    PRIMES[(n) as usize] as u32
}

fn primes(limit: usize) -> Vec<usize> {
    let mut primes = Vec::new();

    let mut candidates = vec![true; limit];
    candidates[0] = false;
    candidates[1] = false;

    let max = (limit as f64).sqrt() as usize;
    let mut n = 2;

    while n <= max {
        primes.push(n);
        // mark
        for v in candidates.iter_mut().skip(n*n).step_by(n) {
            *v = false;
        }
        n = next_prime(n, &candidates, max);
    }

    // collect not marked
    for (i,v) in candidates.iter().enumerate().skip(n) {
        if *v {
            primes.push(i);
        }
    }

    primes
}

fn next_prime(n: usize, candidates: &[bool], default: usize) -> usize {
    for (i,v) in candidates.iter().enumerate().skip(n+1) {
        if *v {
            return i;
        }
    }
    default
}