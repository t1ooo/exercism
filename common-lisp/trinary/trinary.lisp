(defpackage #:trinary
  (:use #:common-lisp)
  (:export #:to-decimal))

(in-package #:trinary)

(defun to-decimal (str)
  (loop for ch across (reverse str) 
        for i from 0
        for num = (digit-char-p ch 3)
    if (not num)
      return 0
    sum (* num (expt 3 i))))