(defpackage #:perfect-numbers
  (:use #:common-lisp)
  (:export #:classify))

(in-package #:perfect-numbers)

(defun factors (n)
  (when (< 1 n)
    (cons 1 
      (loop for i from 2 to (isqrt n)
            for i2 = (/ n i)
        if (zerop (mod n i))
          collect i
          and if (/= i i2) collect i2))))

(defun classify (n)
  (when (< 0 n)
    (let ((fct (apply '+ (factors n))))
      (cond
        ((= n fct) "perfect")
        ((< n fct) "abundant")
        ((> n fct) "deficient")))))