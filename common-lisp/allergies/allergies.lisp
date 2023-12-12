(in-package #:cl-user)
(defpackage #:allergies
  (:use #:common-lisp)
  (:shadow #:list)
  (:export #:allergic-to-p #:list))

(in-package #:allergies)

(defvar items '(
  ("eggs" 1)
  ("peanuts" 2)
  ("shellfish" 4)
  ("strawberries" 8)
  ("tomatoes" 16)
  ("chocolate" 32)
  ("pollen" 64)
  ("cats" 128)))

(defun test (a b)
  (/= 0 (logand a b)))

(defun list (score) 
  (loop for (itm scr) in items
    if (test score scr)
      collect itm))

(defun allergic-to-p (score item) 
  (not (null (find item (list score) :test 'string-equal))))