(defpackage common-lisp-1-a
  (:use :cl)
  (:shadow #:type)
  (:export :make-pokemon :battle))
(in-package :common-lisp-1-a)

(defclass pokemon ()
  ((name
    :initarg :name
    :accessor name)
   (type
    :initarg :type
    :accessor type) 
   (atk
    :initarg :atk
    :accessor atk)
   (hp
    :initarg :hp
    :accessor hp)))
    
(defun make-pokemon (&key name type atk hp)
  (make-instance 'pokemon :name name :type type :atk atk :hp hp))

(defun type-modifier (attacker defender)
	(let ((types (list (type attacker) (type defender))))
		(cond
			((equal types (list 'fire 'grass)) 2)
			((equal types (list 'grass 'fire)) 0.5)
			
			((equal types (list 'grass 'water)) 2)
			((equal types (list 'water 'grass)) 0.5)
			
			((equal types (list 'water 'fire)) 2)
			((equal types (list 'fire 'water)) 0.5)
			
			(t 1))))

(defun calc-hp (attacker defender)
	(decf (hp defender) (* (atk attacker) (type-modifier attacker defender))))

(defun do-battle(first second)
	(loop while (and (< 0 (hp first)) (< 0 (hp second))) do
		(calc-hp first second)
		(calc-hp second first))
	(cond 
		((<= (hp second) 0) first)
		(t second)))
    
(defun battle (first second) 
	(name (do-battle first second)))
