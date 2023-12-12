#![feature(test)]

extern crate test;

use test::Bencher;

#[bench]
fn bench_solve(b: &mut Bencher) {
    b.iter(|| alphametics::solve("AND + A + STRONG + OFFENSE + AS + A + GOOD == DEFENSE"));
}

// #[bench]
// fn bench_perms(b: &mut Bencher) {
//     let mut g = alphametics::perms(10);
//     b.iter(|| g());
// }

// #[bench]
// fn bench_perms_2(b: &mut Bencher) {
//     b.iter(|| alphametics::perms(&[1,2]));
// }

// #[bench]
// fn bench_uniq_num_perms(b: &mut Bencher) {
//     let mut f = alphametics::uniq_num_perms(2);
//     b.iter(|| {
//         while let Some(n) = f() {
//             println!("{:?}",n);
//         }
//     });
// }

// #[bench]
// fn bench_uniq_num_perms(b: &mut Bencher) {
//     b.iter(|| {
//         for _ in alphametics::UniqNumPerms::new(5) {}
//     });
// }

// #[bench]
// fn bench_is_equal(b: &mut Bencher) {
//     let args = &[vec!['I'], vec!['B', 'B']];
//     let res = &['I', 'L', 'L'];
//     let dict = &[('I', 1), ('B', 9), ('L', 0)].iter().cloned().collect();
//     b.iter(|| alphametics::is_equal(args, res, dict));
// }
