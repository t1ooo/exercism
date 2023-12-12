(defpackage #:collatz-conjecture
  (:use #:common-lisp)
  (:export #:collatz))

(in-package #:collatz-conjecture)

(defun cstep (n)
  (if (evenp n)
    (/ n 2)
    (1+ (* 3 n))))

(defun collatz (n)
  (when (< 0 n)
    (let ((num 0))
      (loop while (/= n 1) do
        (incf num)
        (setf n (cstep n)))
    num)))