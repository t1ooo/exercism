(in-package #:cl-user)
(defpackage #:triangle
  (:use #:cl)
  (:export #:triangle))

(in-package #:triangle)

(defun triangle (a b c)
  (cond
    ((or (<= (+ a b) c) (<= (+ a c) b) (<= (+ b c) a)) :illogical)
    ((= a b c) :equilateral)
    ((or (= a b) (= a c) (= b c)) :isosceles)
    (t :scalene)))