(defpackage #:atbash-cipher
  (:use #:common-lisp)
  (:export #:encode))

(in-package #:atbash-cipher)

(defvar dict "abcdefghijklmnopqrstuvwxyz")

(defun clean (str)
  (remove-if-not #'alphanumericp (string-downcase str)))

(defun convert (ch)
  (if (digit-char-p ch)
    ch
    (char (reverse dict) (position ch dict))))

(defun encode (plaintext)
  (format nil "~{~5@{~a~}~^ ~}"
    (loop for ch across (clean plaintext)
      collect (convert ch))))