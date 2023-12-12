(in-package #:cl-user)
(defpackage #:luhn
  (:use #:cl)
  (:export #:is-valid))

(in-package #:luhn)

(defun double-digit(n)
  (let ((v (* n 2)))
    (when (< 9 v)
      (decf v 9))
    v))

(defun list-sum(lst)
  (reduce '+ lst))

(defun sum(input)
  (loop for i from 0 below (length input)
    for x = (digit-char-p (char input i))
    if (oddp i)
      collect (double-digit x) into digits
    else
      collect x into digits
    finally (return (list-sum digits))))

(defun divisiblep(n m)
  (= 0 (rem n m)))

(defun valid-char-p(ch)
    (find ch "0123456789"))

(defun validp(str)
  (and (< 1 (length str))
       (every 'valid-char-p str)))

(defun remove-spaces(str)
  (remove-if (lambda(v) (char= v #\Space)) str))

(defun is-valid (input)
  (let ((v (remove-spaces input)))
    (when (validp v)
      (divisiblep (sum (reverse v)) 10))))