(in-package #:cl-user)
(defpackage #:armstrong-numbers
  (:use #:cl)
  (:export #:armstrong-number-p))
(in-package #:armstrong-numbers)

(defun number-to-digits (num) 
  (map 'list #'digit-char-p (write-to-string num)))

(defun calc-sum (num)
  (let ((digits (number-to-digits num)))
    (loop for digit in digits sum
      (expt digit (length digits)))))

(defun armstrong-number-p (num)
  (= num (calc-sum num)))