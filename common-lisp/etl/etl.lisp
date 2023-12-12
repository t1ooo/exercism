(in-package #:cl-user)
(defpackage #:etl
  (:use #:common-lisp)
  (:export #:transform))

(in-package #:etl)

(defun transform (ht)
  (let ((res (make-hash-table :test 'equalp)))
    (loop for vs being each hash-values of ht using (hash-key k) 
      append (loop for v in vs do
        (setf (gethash v res) k)))
    res))