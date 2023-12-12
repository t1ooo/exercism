(in-package #:cl-user)
(defpackage #:binary-search
  (:use #:common-lisp)
  (:export #:binary-find #:value-error))

(in-package #:binary-search)

(defun last-index (arr)
  (- (length arr) 1))

(defun binary-find (arr el &optional (left 0) (right (last-index arr)))
  (when (<= left right)
    (let* ((i (floor (+ left right) 2))
           (curr (elt arr i)))
      (cond
        ((= curr el) i)
        ((< curr el) (binary-find arr el (+ i 1) right))
        ((> curr el) (binary-find arr el left (- i 1)))))))
