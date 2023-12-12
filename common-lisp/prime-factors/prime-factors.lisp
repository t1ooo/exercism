(defpackage #:prime-factors
  (:use #:common-lisp)
  (:export :factors-of))

(in-package #:prime-factors)

(defun factors-of (n)
  (let ((p 2))
    (loop while (< 1 n)
      if (= 0 (rem n p))
        collect p
        and do (setf n (floor n p))
      else
        do (incf p))))