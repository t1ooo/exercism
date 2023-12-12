#[derive(Debug, PartialEq)]
pub enum Comparison {
    Equal,
    Sublist,
    Superlist,
    Unequal,
}

pub fn sublist<T: PartialEq>(a: &[T], b: &[T]) -> Comparison {
    if a == b {
        return Comparison::Equal;
    }
    if a.len() < b.len() && is_sublist(a, b) {
        return Comparison::Sublist;
    }
    if a.len() > b.len() && is_sublist(b, a) {
        return Comparison::Superlist;
    }
    Comparison::Unequal
}

fn is_sublist<T: PartialEq>(sublist: &[T], list: &[T]) -> bool {
    if sublist.is_empty() {
        return true;
    }
    if list.is_empty() {
        return false;
    }
    list.windows(sublist.len()).any(|chunk| sublist == chunk)
}
