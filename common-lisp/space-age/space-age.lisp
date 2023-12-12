(in-package #:cl-user)
(defpackage #:space-age
  (:use #:common-lisp)
  (:export
    #:on-earth
    #:on-jupiter
    #:on-mars
    #:on-mercury
    #:on-neptune
    #:on-saturn
    #:on-uranus
    #:on-venus))

(in-package #:space-age)

(defun calc-years (seconds period) 
  (/ seconds (* period 31557600)))

(defun on-earth (seconds) (calc-years seconds 1))
(defun on-jupiter (seconds) (calc-years seconds 11.862615))
(defun on-mars (seconds) (calc-years seconds 1.8808158))
(defun on-mercury (seconds) (calc-years seconds 0.2408467))
(defun on-neptune (seconds) (calc-years seconds 164.79132))
(defun on-saturn (seconds) (calc-years seconds 29.447498))
(defun on-uranus (seconds) (calc-years seconds 84.016846))
(defun on-venus (seconds) (calc-years seconds 0.61519726))