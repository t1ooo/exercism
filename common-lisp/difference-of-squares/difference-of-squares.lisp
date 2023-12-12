(defpackage #:squares
  (:use #:cl)
  (:export #:sum-of-squares
           #:square-of-sum
           #:difference))

(in-package #:squares)

(defun sum-of-squares (n)
  ;; n(n+1)(2n+1)/6
  (/ (* n (1+ n) (1+ (* 2 n))) 6))

(defun sum-of-naturals-nums  (n)
  ;; n(n+1)/2
  (/ (* n (1+ n)) 2))  

(defun square-of-sum (n)
  (expt (sum-of-naturals-nums n) 2))

(defun difference (n)
  (- (square-of-sum n) (sum-of-squares n)))