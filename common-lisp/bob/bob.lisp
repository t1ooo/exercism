(in-package #:cl-user)
(defpackage #:bob
  (:use #:cl)
  (:export #:response))
(in-package #:bob)

(defun last-char(str)
  (when (string/= "" str)
    (char str (1- (length str)))))

(defun questionp (msg)
  (char= #\? (last-char msg)))

(defun all-capitals-p (msg)
  (and (string/= msg (string-downcase msg)) (string= msg (string-upcase msg))))

(defun nothingp (msg) (string= "" msg))

(defun normalize(msg) (string-trim (format nil "~% 	") msg))

(defun response (hey-bob)
  (let ((msg (normalize hey-bob)))
    (cond
      ((nothingp msg) "Fine. Be that way!")
      ((and (questionp msg) (all-capitals-p msg)) "Calm down, I know what I'm doing!")
      ((questionp msg) "Sure.")
      ((all-capitals-p msg) "Whoa, chill out!")
      (t "Whatever."))))