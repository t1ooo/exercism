use crossbeam::channel::bounded;
use std::collections::HashMap;
use std::thread;

pub fn frequency(input: &[&str], worker_count: usize) -> HashMap<char, usize> {
    let (send_res, recv_res) = bounded(input.len());
    let (send_job, recv_job) = bounded(input.len());

    for _ in 0..worker_count {
        let send_res = send_res.clone();
        let recv_job = recv_job.clone();
        thread::spawn(move || {
            for val in recv_job {
                send_res.send(freq(val)).unwrap();
            }
        });
    }

    for str in input {
        send_job.send(str.to_string()).unwrap();
    }
    drop(send_job);
    drop(send_res);

    let mut hm = HashMap::new();
    for res in recv_res {
        merge(&mut hm, res);
    }

    hm
}

fn freq(input: String) -> HashMap<char, usize> {
    let mut hm = HashMap::new();
    input
        .chars()
        .filter(|ch| ch.is_alphabetic())
        .for_each(|ch| {
            ch.to_lowercase().for_each(|ch_lc| {
                *hm.entry(ch_lc).or_insert(0) += 1;
            });
        });
    hm
}

fn merge(dest: &mut HashMap<char, usize>, src: HashMap<char, usize>) {
    for (k, v) in src.iter() {
        *dest.entry(*k).or_insert(0) += v;
    }
}
