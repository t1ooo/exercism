(in-package #:cl-user)
(defpackage #:gigasecond
  (:use #:cl)
  (:export #:from))
(in-package #:gigasecond)

(defvar timezone 0)
(defvar gigasecond (expt 10 9))

(defun format-date (sec)
  (cdddr (reverse (multiple-value-list (decode-universal-time sec timezone)))))

(defun from (year month day hour minute second)
  (format-date (+ gigasecond (encode-universal-time second minute hour day month year timezone))))