(in-package #:cl-user)
(defpackage #:pascal
  (:use #:cl)
  (:export #:rows))
(in-package #:pascal)

;; nth with support negative index
(defun nthn (n lst)
  (if (< n 0)
    nil
    (nth n lst)))

(defmacro push-to-end(item lst)
  `(if (not ,lst)
    (push ,item ,lst)
    (push ,item (cdr (last ,lst)))))

(defun gen-row (prev)
  (if (not prev)
    (list 1)
    (loop for i from 0 to (length prev)
          for a = (or (nthn i prev) 0)
          for b = (or (nthn (1- i) prev) 0)
            collect (+ a b))))

(defun rows (n)
  (let ((res))
    (loop for i from 0 below n
          for prev = (or (nthn (1- i) res) nil)
          for curr = (gen-row prev)
            do (push-to-end curr res))
    res))