(defpackage #:school
  (:use #:common-lisp)
  (:export #:make-school #:add #:grade-roster #:grade #:sorted))

(in-package #:school)

(defun make-school ()
  (make-hash-table))

(defun add (school name grade)
  (push name (gethash grade school)))

(defun grade (school grade)
  (gethash grade school))

(defun grade-roster (school)
  (loop for v being each hash-values of school using (hash-key k)
    collect (list :grade k :students v)))

(defun sorted (school)
  (sort (grade-roster school) '< :key 'second))