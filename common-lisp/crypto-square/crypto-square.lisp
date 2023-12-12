(in-package #:cl-user)
(defpackage #:crypto-square
  (:use #:cl)
  (:export #:encipher))
(in-package #:crypto-square)

(defun normalize (str)
  (remove-if-not 'alphanumericp (string-downcase str)))

(defun cols (strlen)
  (ceiling (sqrt strlen)))

(defun rows (strlen)
  (round (sqrt strlen)))

(defun pad-space-right (len str)
  (format nil (format nil "~~~Aa" len) str))

(defun join-with-space (lst)
  (format nil "~{~a~^ ~}" lst))

(defun join (lst)
  (format nil "~{~a~}" lst))

(defun gen-row (str i c)
  (loop for k from i below (length str) by c 
    collect (char str k)))

(defun encipher (plaintext)
  (let* ((str (normalize plaintext))
         (c (cols (length str)))   
         (r (rows (length str))))
      (join-with-space
        (loop for i from 0 below c 
          collect (pad-space-right r (join (gen-row str i c)))))))