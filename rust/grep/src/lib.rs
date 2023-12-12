use anyhow::Error;
use std::{
    fs::File,
    io::{BufRead, BufReader},
};

/// While using `&[&str]` to handle flags is convenient for exercise purposes,
/// and resembles the output of [`std::env::args`], in real-world projects it is
/// both more convenient and more idiomatic to contain runtime configuration in
/// a dedicated struct. Therefore, we suggest that you do so in this exercise.
///
/// In the real world, it's common to use crates such as [`clap`] or
/// [`structopt`] to handle argument parsing, and of course doing so is
/// permitted in this exercise as well, though it may be somewhat overkill.
///
/// [`clap`]: https://crates.io/crates/clap
/// [`std::env::args`]: https://doc.rust-lang.org/std/env/fn.args.html
/// [`structopt`]: https://crates.io/crates/structopt
#[derive(Debug)]
pub struct Flags {
    line_number: bool,
    ignore_case: bool,
    files_with_matches: bool,
    line_regexp: bool,
    invert_match: bool,
}

impl Flags {
    pub fn new(flags: &[&str]) -> Self {
        Self {
            line_number: flags.contains(&"-n"),
            ignore_case: flags.contains(&"-i"),
            files_with_matches: flags.contains(&"-l"),
            line_regexp: flags.contains(&"-x"),
            invert_match: flags.contains(&"-v"),
        }
    }
}

pub fn grep(pattern: &str, flags: &Flags, files: &[&str]) -> Result<Vec<String>, Error> {
    Grep::new(pattern, flags, files).grep()
}

struct Grep<'a> {
    pattern: &'a str,
    flags: &'a Flags,
    files: &'a [&'a str],
}

impl<'a> Grep<'a> {
    fn new(pattern: &'a str, flags: &'a Flags, files: &'a [&'a str]) -> Self {
        Grep {
            pattern,
            flags,
            files,
        }
    }

    fn grep(&self) -> Result<Vec<String>, Error> {
        let mut res: Vec<String> = vec![];

        for file in self.files {
            let fh = File::open(file)?;
            let reader = BufReader::new(fh);
            for (i, r_line) in reader.lines().enumerate() {
                let line = r_line?;
                if self.mtch(&line) {
                    if self.flags.files_with_matches {
                        push_uniq(&mut res, file.to_string());
                    } else {
                        res.push(self.fmt(i, &line, file))
                    }
                }
            }
        }

        Ok(res)
    }

    fn fmt(&self, i: usize, line: &str, file: &str) -> String {
        let mut s = if self.flags.line_number {
            format!("{}:{}", i + 1, line)
        } else {
            line.to_string()
        };

        if self.files.len() > 1 {
            s = format!("{}:{}", file, s);
        }

        s
    }

    fn mtch(&self, line: &str) -> bool {
        let (p_pattern, p_line) = if self.flags.ignore_case {
            (self.pattern.to_uppercase(), line.to_uppercase())
        } else {
            (self.pattern.to_string(), line.to_string())
        };

        let mut m = if self.flags.line_regexp {
            p_line == p_pattern
        } else {
            p_line.contains(&p_pattern)
        };

        if self.flags.invert_match {
            m = !m
        }

        m
    }
}

fn push_uniq<T: Eq>(v: &mut Vec<T>, val: T) {
    if !v.contains(&val) {
        v.push(val);
    }
}
