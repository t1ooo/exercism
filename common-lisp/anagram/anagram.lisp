(in-package #:cl-user)
(defpackage #:anagram
  (:use #:common-lisp)
  (:export #:anagrams-for))

(in-package #:anagram)


(defun string-sort (str)
  (sort (copy-seq str) #'string-lessp))

(defun anagramp (word anagram)
  (and
    (string-not-equal word anagram)
    (string-equal
      (string-sort word)
      (string-sort anagram))))

(defun anagrams-for (word anagrams)
  (remove-if-not #'(lambda (x) (anagramp word x)) anagrams))