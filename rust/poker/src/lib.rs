use self::hand_hasher::hash;
use num::integer::Integer;
use std::collections::HashMap;
use std::hash::Hash;

/// Given a list of poker hands, return a list of those hands which win.
pub fn winning_hands<'a>(hands: &[&'a str]) -> Option<Vec<&'a str>> {
    Some(maxs_by(hands, |x| hash(&Hand::from(*x))))
}

fn maxs_by<T: Copy, H: Ord, F: FnMut(&T) -> H>(a: &[T], hasher: F) -> Vec<T> {
    let hashes = a.iter().map(hasher).collect::<Vec<H>>();
    let max = hashes.iter().max().unwrap();
    hashes
        .iter()
        .zip(a.iter())
        .filter(|(h, _)| *h == max)
        .map(|(_, s)| *s)
        .collect()
}

struct Card {
    rank: String,
    suit: char,
}

impl Card {
    fn new(rank: String, suit: char) -> Self {
        Self { rank, suit }
    }
}

impl From<&str> for Card {
    fn from(s: &str) -> Self {
        match s.len() {
            3 => Self::new(s[0..2].to_string(), s.chars().nth(2).unwrap()),
            2 => Self::new(
                s.chars().nth(0).unwrap().to_string(),
                s.chars().nth(1).unwrap(),
            ),
            _ => panic!("not valid str"),
        }
    }
}

enum Type {
    HighCard = 1,
    Pair,
    TwoPair,
    ThreeOfAKind,
    Straight,
    Flush,
    FullHouse,
    FourOfAKind,
    StraightFlush,
}

pub struct Hand(Vec<Card>);

impl From<&str> for Hand {
    fn from(s: &str) -> Self {
        Self(s.split(' ').map(Card::from).collect())
    }
}

impl Hand {
    fn ranks(&self) -> Vec<String> {
        self.0.iter().map(|x| x.rank.clone()).collect()
    }

    #[rustfmt::skip]
    fn num_ranks(&self) -> Vec<usize> {
        let ranks = self.ranks();
        let weights = if second_max(&ranks) == "5" {
            ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Q", "K", "J", "_",]
        } else {
            ["_", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Q", "K", "A", "J",]
        };
        ranks.iter().map(|x| index_of(&weights, &x)).collect()
    }

    fn suits(&self) -> Vec<char> {
        self.0.iter().map(|x| x.suit).collect()
    }

    fn typ(&self) -> Type {
        let num_ranks = self.num_ranks();

        let same_suit = is_all_same(&self.suits());
        let rank_seq = is_seq(&num_ranks);

        if same_suit && rank_seq {
            return Type::StraightFlush;
        }

        if same_suit {
            return Type::Flush;
        }

        if rank_seq {
            return Type::Straight;
        }

        let mut g_counts = groups_counts(&self.ranks());
        g_counts.sort_by(|a, b| b.cmp(a));
        match g_counts.as_slice() {
            [4] => Type::FourOfAKind,
            [3, 2] => Type::FullHouse,
            [3] => Type::ThreeOfAKind,
            [2, 2] => Type::TwoPair,
            [2] => Type::Pair,
            [] => Type::HighCard,
            _ => panic!("not valid group counts"),
        }
    }
}

fn second_max<T: Clone + Ord>(v: &[T]) -> T {
    let mut copy = v.to_owned();
    copy.sort_by(|a, b| b.cmp(a));
    copy[1].clone()
}

fn groups_counts<T: Clone + Eq + Hash>(v: &[T]) -> Vec<usize> {
    let counts = count_vals(v);
    let mut lens = vec![];
    for (_, v) in counts {
        if 1 < v {
            lens.push(v);
        }
    }
    lens
}

fn is_all_same<T: Copy + Eq>(v: &[T]) -> bool {
    v.iter().all(|&x| x == v[0])
}

fn is_seq<I: Clone + Integer>(v: &[I]) -> bool {
    let mut copy = v.to_owned();
    copy.sort_unstable();
    copy.windows(2).all(|v| v[0] == v[1].clone() - I::one())
}

fn index_of<T: Eq>(v: &[T], value: T) -> usize {
    v.iter().position(|x| *x == value).unwrap()
}

fn count_vals<T: Clone + Eq + Hash>(v: &[T]) -> HashMap<T, usize> {
    let mut counts = HashMap::new();
    for v in v {
        *counts.entry(v.clone()).or_insert(0) += 1;
    }
    counts
}

mod hand_hasher {
    use super::{count_vals, Hand};
    use core::cmp::Ordering::{Equal, Greater, Less};

    pub fn hash(hand: &Hand) -> usize {
        let mut nums = num_ranks_sorted(hand);
        let typ = hand.typ();
        nums.insert(0, typ as usize);
        nums_to_num(nums)
    }

    fn num_ranks_sorted(hand: &Hand) -> Vec<usize> {
        let mut s_ranks = hand.num_ranks();
        let counts = count_vals(&s_ranks);
        s_ranks.sort_by(|a, b| match counts[b].cmp(&counts[a]) {
            Greater => Greater,
            Less => Less,
            Equal => b.cmp(a),
        });
        s_ranks
    }

    fn nums_to_num(nums: Vec<usize>) -> usize {
        nums.iter()
            .rev()
            .enumerate()
            .map(|(i, x)| x * 10_usize.pow(i as u32))
            .sum()
    }
}
