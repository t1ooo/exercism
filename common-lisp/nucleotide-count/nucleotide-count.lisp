(in-package #:cl-user)
(defpackage #:dna
  (:use #:common-lisp)
  (:export #:dna-count #:nucleotide-counts #:invalid-nucleotide))

(in-package #:dna)

(defvar valid-nucleotides "ATCG")

(defun make-dna-hash-table () 
  (let ((ht (make-hash-table)))
    (loop for nucl across valid-nucleotides do
      (setf (gethash nucl ht) 0))
    ht))

(defun  nucleotide-counts (dna) 
  (let ((res (make-dna-hash-table)))
    (loop for nucl across dna do
      (incf (gethash nucl res)))
    res))

(define-condition invalid-nucleotide (error) ())

(defun dna-count (nucl dna)
  (unless (find nucl valid-nucleotides)
    (error 'invalid-nucleotide))
  (count nucl dna))