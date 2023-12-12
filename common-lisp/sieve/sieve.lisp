(defpackage #:sieve
  (:use #:cl)
  (:export #:primes-to)
  (:documentation "Generates a list of primes up to a given limit."))

(in-package #:sieve)

(defun gen-array(max)
  (make-array max :initial-element t))

(defun mark (p arr)
  (loop for i from (expt p 2) below (length arr) by p 
    do (setf (aref arr i) nil)))

(defun find-greater-num (p arr)
  (loop for i from (1+ p) below (length arr)
    if (aref arr i)
      return i))

(defun collect-nums (arr)
  (loop for i from 2 below (length arr)
    if (aref arr i)
      collect i))
  
(defun primes-to (max)
  (let ((arr (gen-array (1+ max)))
        (p 2))   
    (loop while (< (expt p 2) max) do     
      (mark p arr)  
      (setf p (find-greater-num p arr)))
    (collect-nums arr)))
