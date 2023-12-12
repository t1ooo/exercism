(in-package #:cl-user)
(defpackage #:two-fer
  (:use #:cl)
  (:export #:twofer))
(in-package #:two-fer)

; #1
; (defun twofer (&optional name)
  ; (if (= (length name) 0) (setq name "you"))
  ; (format nil "One for ~A, one for me." name))

; #2
; (defun twofer (&optional name)
  ; (let ((name (if (= (length name) 0) "you" name))) 
    ; (format nil "One for ~A, one for me." name)))

; #3 
; (defun twofer (&optional name)
  ; (if (= (length name) 0) 
    ; (format nil "One for ~A, one for me." "you")
    ; (format nil "One for ~A, one for me." name)))

; #4 
; (defun foo(name) 
    ; (format nil "One for ~A, one for me." name))
 
; (defun twofer (&optional name)
  ; (if (= (length name) 0) 
    ; (foo "you")
    ; (foo name)))