(ql:quickload "lisp-unit")
#-xlisp-test (load "nucleotide-count")

(defpackage #:nucleotide-count-test
  (:use #:common-lisp #:lisp-unit))

(in-package #:nucleotide-count-test)

(defun make-hash (kvs)
  (reduce
   #'(lambda (h kv) (setf (gethash (first kv) h) (second kv)) h)
   kvs
   :initial-value (make-hash-table)))

(define-test empty-dna-strand-has-no-adenine
  (assert-equal 0 (dna:dna-count #\A "")))

(define-test empty-dna-strand-has-no-nucleotides
  (assert-equalp (make-hash '((#\A 0) (#\T 0) (#\C 0) (#\G 0)))
    (dna:nucleotide-counts "")))

(define-test repetitive-cytosine-gets-counted
  (assert-equal 5 (dna:dna-count #\C "CCCCC")))

(define-test repetitive-sequence-has-only-guanine
  (assert-equalp (make-hash '((#\A 0) (#\T 0) (#\C 0) (#\G 8)))
    (dna:nucleotide-counts "GGGGGGGG")))

(define-test counts-only-thymine
  (assert-equal 1 (dna:dna-count #\T "GGGGGTAACCCGG")))

(define-test validates-nucleotides
  (assert-error 'dna:invalid-nucleotide (dna:dna-count #\X "GACT")))

(define-test counts-all-nucleotides
  (assert-equalp (make-hash '((#\A 20) (#\T 21) (#\G 17) (#\C 12)))
    (dna:nucleotide-counts
      "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC")))

#-xlisp-test
(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :nucleotide-count-test))
