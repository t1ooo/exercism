(defpackage #:raindrops
  (:use #:common-lisp)
  (:export #:convert))

(in-package #:raindrops)

(defun join (lst)
  (format nil "~{~a~}" lst))

(defun factorp (a b)
  (zerop (rem a b)))

(defun convert (num)
  (let ((res '()))
    (when (factorp num 3) (push "Pling" res))
    (when (factorp num 5) (push "Plang" res))
    (when (factorp num 7) (push "Plong" res))
    (if res
      (join (reverse res))
      (write-to-string num))))