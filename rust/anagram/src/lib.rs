use std::collections::HashSet;

pub fn anagrams_for<'a>(word: &str, possible_anagrams: &[&'a str]) -> HashSet<&'a str> {
    let word_lc = word.to_lowercase();
    let word_normalize = normalize(&word_lc);
    possible_anagrams
        .iter()
        .cloned()
        .filter(|anagram| {
            let anagram_lc = anagram.to_lowercase();
            anagram_lc != word_lc && normalize(&anagram_lc) == word_normalize
        })
        .collect::<HashSet<&'a str>>()
}

fn normalize(word: &str) -> Vec<char> {
    let mut chars: Vec<char> = word.chars().collect();
    chars.sort();
    chars
}
