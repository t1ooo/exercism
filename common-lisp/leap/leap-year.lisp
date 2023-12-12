(defpackage #:leap
  (:use #:common-lisp)
  (:export #:leap-year-p))
(in-package #:leap)

(defun leap-year-p (y)
  (or (divisiblep y 400)
      (and (divisiblep y 4)
           (not (divisiblep y 100)))))

(defun divisiblep(a b)
  (zerop (rem a b)))