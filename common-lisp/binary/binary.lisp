(defpackage #:binary
  (:use :common-lisp)
  (:export :to-decimal))

(in-package :binary)

(defun remove-not-digits (input) 
  (remove-if-not #'digit-char-p input))

(defun validp (input)
  (every (lambda (x) (find x "01") ) input))

(defun to-decimal (input)
  (let ((str (remove-not-digits input)))
    (unless (validp str)
      (return-from to-decimal 0))
    (loop for ch across (reverse str) 
          and i from 0 
            sum (* (digit-char-p ch) (expt 2 i)))))