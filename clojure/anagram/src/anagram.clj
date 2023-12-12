(ns anagram
  (:require [clojure.string :refer (lower-case)]))

(defn anagram? [word freq prospect]
  (let [prospect (lower-case prospect)]
    (and
     (not= word prospect)
     (= freq (frequencies prospect)))))

(defn anagrams-for [word prospect-list]
  (let [word (lower-case word)
        freq (frequencies word)]
    (filter (partial anagram? word freq) prospect-list)))
