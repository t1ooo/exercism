(defpackage #:scrabble-score
(:use #:cl)
(:export #:score-word))

(in-package #:scrabble-score)

(defvar letter-values '(
  ((#\A #\E #\I #\O #\U #\L #\N #\R #\S #\T) 1)
  ((#\D #\G) 2)
  ((#\B #\C #\M #\P) 3)
  ((#\F #\H #\V #\W #\Y) 4)
  ((#\K) 5)
  ((#\J #\X) 8)
  ((#\Q #\Z) 10)))

(defun score-word (word)
  (loop for (letters value) in letter-values sum
    (loop for letter in letters sum 
      (* value (count letter word :test 'char-equal)))))