(in-package #:cl-user)
(defpackage #:acronym
  (:use #:common-lisp)
  (:export #:acronym))

(in-package #:acronym)

(defun split (str)
  (uiop:split-string str :separator " -"))

(defun join (lst)
  (format nil "~{~A~}" lst))

(defun extract-first-letter (str)
 (subseq str 0 1))

(defun acronym (str)
  (string-upcase 
    (join 
      (map 'list #'extract-first-letter (split str)))))