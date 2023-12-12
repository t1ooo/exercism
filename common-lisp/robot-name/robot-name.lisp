(in-package #:cl-user)
(defpackage #:robot
  (:use #:common-lisp)
  (:export #:build-robot #:robot-name #:reset-name))

(in-package #:robot)

(defvar names (make-hash-table :test 'equal))

(defun has-name (name)
 (gethash name names))

(defun set-name (name)
 (setf (gethash name names) t))

(defun del-name (name)
  (remhash name names))

(defvar dict "QWERTYUIOPASDFGHJKLZXCVBNM")

(defclass robot ()
  ((name
    :initarg :name
    :accessor name)))

(defun random-char (str)
  (char str (random (length str))))

(defun generate-name ()
  (format nil "~a~a~a"
    (random-char dict)
    (random-char dict)
    (random 1000)))

(defun generate-uniq-name ()
  (let ((name (generate-name)))
    (if (has-name name) 
      (generate-uniq-name) 
      (progn 
        (set-name name)
        name))))

(defun build-robot ()
  (make-instance 'robot :name (generate-uniq-name)))

(defun robot-name (rbt)
  (name rbt))

(defun reset-name (rbt)
  (del-name (robot-name rbt))
  (setf (name rbt) (generate-name)))