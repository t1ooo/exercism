(defpackage #:strain
  (:use #:common-lisp)
  (:export #:keep #:discard))

(in-package #:strain)

(defun keep (test lst)
  (if (not lst)
    (return-from keep nil)
  (let ((head (car lst)) 
        (tail (cdr lst)))
    (if (funcall test head)
      (append (list head) (keep test tail))
      (keep test tail)))))
  
(defun discard (test lst)
  (keep (complement test) lst))