#[derive(Debug, PartialEq)]
pub enum Error {
    InvalidRowCount(usize),
    InvalidColumnCount(usize),
}

const DIFF_X: usize = 3;
const DIFF_Y: usize = 4;

pub fn convert(input: &str) -> Result<String, Error> {
    let lines = input
        .split('\n')
        .map(|x| x.to_string())
        .collect::<Vec<String>>();

    // validate
    if lines.len() % DIFF_Y != 0 {
        return Err(Error::InvalidRowCount(lines.len()));
    }
    for line in &lines {
        if line.len() % DIFF_X != 0 {
            return Err(Error::InvalidColumnCount(line.len()));
        }
    }

    let mut res = String::new();
    for (v, next_row) in LinesIterator::new(lines) {
        if next_row {
            res.push(',')
        }
        let ch = match index_of(&v) {
            Some(i) => char_from_digit(i),
            _ => '?',
        };
        res.push(ch);
    }
    Ok(res)
}

fn char_from_digit(i: usize) -> char {
    i.to_string().chars().next().unwrap()
}

fn index_of(b: &[String]) -> Option<usize> {
    NUMS.iter().position(|&v| v == b)
}

struct LinesIterator {
    x: usize,
    y: usize,
    lines: Vec<String>,
}

impl LinesIterator {
    fn new(lines: Vec<String>) -> Self {
        LinesIterator { x: 0, y: 0, lines }
    }
}

impl Iterator for LinesIterator {
    type Item = (Vec<String>, bool);

    fn next(&mut self) -> Option<Self::Item> {
        let mut x = self.x;
        let mut y = self.y;
        let mut next_row = false;

        if x >= self.lines[y].len() {
            x = 0;
            y += DIFF_Y;
            next_row = true;
        }
        if y >= self.lines.len() {
            return None;
        }

        self.x = x + DIFF_X;
        self.y = y;

        let value = self
            .lines
            .iter()
            .skip(y)
            .take(DIFF_Y)
            .map(|row| row.chars().skip(x).take(DIFF_X).collect::<String>())
            .collect::<Vec<String>>();

        Some((value, next_row))
    }
}

#[rustfmt::skip]
const NUMS: [[&str; 4]; 10] = [
    [
        " _ ",
        "| |",
        "|_|",
        "   ",
    ], [
        "   ",
        "  |",
        "  |",
        "   ",
    ], [
        " _ ",
        " _|",
        "|_ ",
        "   ",
    ], [
        " _ ",
        " _|",
        " _|",
        "   ",
    ], [
        "   ",
        "|_|",
        "  |",
        "   ",
    ], [
        " _ ",
        "|_ ",
        " _|",
        "   ",
    ], [
        " _ ",
        "|_ ",
        "|_|",
        "   ",
    ], [
        " _ ",
        "  |",
        "  |",
        "   ",
    ], [
        " _ ",
        "|_|",
        "|_|",
        "   ",
    ], [
        " _ ",
        "|_|",
        " _|",
        "   ",
    ],
];
