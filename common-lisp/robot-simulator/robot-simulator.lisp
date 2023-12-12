(in-package #:cl-user)
(defpackage #:robot-simulator
  (:use #:common-lisp)
  (:export #:+north+ #:+east+ #:+south+ #:+west+ #:execute-sequence
           #:robot #:robot-position #:robot-bearing #:make-robot))

(in-package #:robot-simulator)

(defvar +north+ 0)
(defvar +east+ 1)
(defvar +south+ 2)
(defvar +west+ 3)

(defclass robot ()
  ((x
    :initarg :x
    :accessor x)
   (y
    :initarg :y
    :accessor y) 
   (bearing
    :initarg :bearing
    :accessor bearing)))

(defun make-robot (&key (position '(0 . 0)) (bearing +north+))
  (make-instance 'robot :x (car position) :y (cdr position) :bearing bearing))

(defun robot-position (robot)
  (cons (x robot) (y robot)))

(defun robot-bearing (robot) (bearing robot))

(defun sum-bearing (bearing diff)
  (mod (incf bearing diff) 4))

(defun turn (robot diff)
  (setf
    (bearing robot)
    (sum-bearing diff (bearing robot))))

(defun turn-left (robot)
  (turn robot -1))

(defun turn-right (robot) 
    (turn robot +1))

(defun advance (robot)
  (let ((bearing (bearing robot)))
    (ecase bearing
      ((#.+north+) (incf (y robot)))
      ((#.+south+) (decf (y robot)))
      ((#.+east+) (incf (x robot)))
      ((#.+west+) (decf (x robot))))))

(defun execute-command (robot letter) 
  (ecase letter 
    (#\L (turn-left robot))
    (#\R (turn-right robot))
    (#\A (advance robot))))

(defun execute-sequence (robot str) 
  (loop for letter across str do
    (execute-command robot letter)))