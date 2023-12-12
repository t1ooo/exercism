(defpackage #:isogram
  (:use #:cl)
  (:export #:is-isogram))

(in-package #:isogram)

(defun is-isogram (string)
  (let ((str (remove-if-not 'alphanumericp (string-downcase string))))
    (every (lambda(x) (= 1 (count x str))) str)))