pub fn count(lines: &'static [&'static str]) -> u32 {
    lines
        .iter()
        .enumerate()
        .map(|(_y, row)| -> u32 {
            row.chars()
                .enumerate()
                .map(|(_x, v)| {
                    let (x, y) = (_x as i64, _y as i64);
                    match v {
                        '+' => count_r(State::Start, x, y, LinesIterator::new(x, y, lines)),
                        _ => 0,
                    }
                })
                .sum()
        })
        .sum()
}

enum State {
    Start,
    Right,
    Down,
    Left,
    Up,
    Stop,
    Fail,
}

#[derive(Copy, Clone)]
struct LinesIterator {
    x: i64,
    y: i64,
    lines: &'static [&'static str],
}

impl LinesIterator {
    fn new(x: i64, y: i64, lines: &'static [&'static str]) -> Self {
        LinesIterator { x, y, lines }
    }
    fn right(&mut self) -> &Self {
        self.x += 1;
        self
    }
    fn left(&mut self) -> &Self {
        self.x -= 1;
        self
    }
    fn down(&mut self) -> &Self {
        self.y += 1;
        self
    }
    fn up(&mut self) -> &Self {
        self.y -= 1;
        self
    }
    fn value(&self) -> Option<char> {
        match self.lines.get(self.y as usize) {
            Some(s) => s.chars().nth(self.x as usize),
            _ => None,
        }
    }
}

// x, y - rectangle start coordinates (left top corner)
fn count_r(state: State, x: i64, y: i64, mut iter: LinesIterator) -> u32 {
    match state {
        State::Start => count_r(State::Right, x, y, iter),

        State::Right => match iter.right().value() {
            Some('-') => count_r(State::Right, x, y, iter),
            Some('+') => {
                count_r(State::Down, x, y, iter) // rectangle
                + count_r(State::Right, x, y, iter) // composite rectangle
            }
            _ => count_r(State::Fail, x, y, iter),
        },

        State::Down => match iter.down().value() {
            Some('|') => count_r(State::Down, x, y, iter),
            Some('+') => {
                count_r(State::Left, x, y, iter) // rectangle
                + count_r(State::Down, x, y, iter) // composite rectangle
            }
            _ => count_r(State::Fail, x, y, iter),
        },

        State::Left => match iter.left().value() {
            Some('-') => count_r(State::Left, x, y, iter),
            Some('+') => {
                count_r(State::Up, x, y, iter) // rectangle
                + count_r(State::Left, x, y, iter) // composite rectangle
            }
            _ => count_r(State::Fail, x, y, iter),
        },

        State::Up => match iter.up().value() {
            Some('|') => count_r(State::Up, x, y, iter),
            Some('+') => {
                count_r(State::Stop, x, y, iter) // rectangle
                + count_r(State::Up, x, y, iter) // composite rectangle
            }
            _ => count_r(State::Fail, x, y, iter),
        },

        State::Fail => 0,

        State::Stop => {
            let is_rectangle = x == iter.x && y == iter.y;
            is_rectangle as u32
        }
    }
}
