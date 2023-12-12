let nums = [
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

struct S {
    x: i64
    y: i64
    lines &[&str],
}

impl Iterator for S {
    type Item = &[&str];

    fn next(&mut self) -> Option<Self::Item> {
        let diff_x = 3;
        let diff_y = 4;

        let x = self.x;
        let y = self.y;

        let next_x = x + diff_x;
        let next_y = y + diff_y;


        if !(next_x < self.lines[next_y].len()) {
            next_x = 0;
        }
        if !(next_y < self.lines.len()) {
            return None;
        }

        let res = self.lines.iter().skip(self.y).take(4).map(|row| {
            row.chars().skip(self.x).take(3)
        })


        
    }
}

for v in iter.next() {
    for (i,n) in nums {
        if v == n {
            res.push(i.to_string())
        }
    }
}