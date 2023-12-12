(in-package #:cl-user)
(defpackage #:phone
  (:use #:common-lisp)
  (:export #:numbers #:area-code #:pretty-print))

(in-package #:phone)

(defun clean (str)
  (remove-if-not #'digit-char-p str))

(defun remove-country-code (num)
  (if (and (= 11 (length num)) (char= #\1 (char num 0)))
    (subseq num 1)
    num))

(defun numbers (number)
  (let ((num (remove-country-code (clean number))))
    (if (= 10 (length num))
      num
      "0000000000")))

(defun area-code (number)
  (subseq number 0 3))

(defun pretty-print (number)
  (let ((num (numbers number)))
    (format nil "(~a) ~a-~a"
      (subseq num 0 3)
      (subseq num 3 6)
      (subseq num 6))))