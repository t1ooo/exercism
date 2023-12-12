(in-package #:cl-user)
(defpackage #:all-your-base
  (:use #:common-lisp)
  (:export #:rebase))

(in-package #:all-your-base)

(defun to-dec (digits base)
  (loop for n in (reverse digits) and i from 0
    sum (* n (expt base i))))

(defun int-div (a b)
  (nth-value 0 (floor a b)))

(defun from-dec (num base)
  (let ((res '()))
    (loop while (< 0 num) do
      (push (rem num base) res)
      (setf num (int-div num base)))
    res))

(defun rebase (digits in-base out-base)
  (cond 
    ((<= in-base 1) nil)
    ((<= out-base 1) nil)
    ((not digits) '(0))
    ((every (lambda(x) (= 0 x)) digits) '(0))
    ((some (lambda(x) (< x 0)) digits) nil)
    ((some (lambda(x) (<= in-base x)) digits) nil)
    (t (from-dec (to-dec digits in-base) out-base))))
