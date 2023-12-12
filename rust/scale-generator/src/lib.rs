#[derive(Debug)]
pub enum Error {
    InvalidTonic,
    InvalidInterval,
}

const FLATS: [&str; 12] = [
    "A", "Bb", "B", "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab",
];

const SHARP: [&str; 12] = [
    "A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#",
];

pub struct Scale(Vec<String>);

impl Scale {
    pub fn new(tonic: &str, intervals: &str) -> Result<Self, Error> {
        let scales = if is_flats(tonic) { FLATS } else { SHARP };

        let c_tonic = capitalize(tonic);
        let mut curr = scales
            .iter()
            .position(|x| x == &c_tonic)
            .ok_or(Error::InvalidTonic)?;

        let mut res = vec![];
        for intr in parse_intervals(intervals)?.iter() {
            res.push(scales[curr % 12].to_string());
            curr += intr;
        }

        Ok(Self(res))
    }

    pub fn chromatic(tonic: &str) -> Result<Scale, Error> {
        Self::new(tonic, "mmmmmmmmmmmm")
    }

    pub fn enumerate(&self) -> Vec<String> {
        self.0.clone()
    }
}

fn is_flats(tonic: &str) -> bool {
    [
        "F", "Bb", "Eb", "Ab", "Db", "Gb", "d", "g", "c", "f", "bb", "eb",
    ]
    .contains(&tonic)
}

fn parse_intervals(intervals: &str) -> Result<Vec<usize>, Error> {
    intervals
        .chars()
        .map(|ch| match ch {
            'm' => Ok(1),
            'M' => Ok(2),
            'A' => Ok(3),
            _ => Err(Error::InvalidInterval),
        })
        .collect()
}

fn capitalize(s: &str) -> String {
    let mut c = s.chars();
    match c.next() {
        None => String::new(),
        Some(f) => f.to_uppercase().chain(c).collect(),
    }
}
