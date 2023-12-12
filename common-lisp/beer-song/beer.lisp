(in-package #:cl-user)
(defpackage #:beer
  (:use #:common-lisp)
  (:export #:verse #:sing))

(in-package #:beer)

(declaim
  (ftype (function (list) string) join-with-newline)
  (ftype (function (integer &optional integer) string) sing)
  (ftype (function (string) string) first-char-upcase)
  (ftype (function (integer) string)
         verse
         bottles-on-wall
         action
         action-take
         bottles
         end-of-word
         number-of-bottles))

(defun sing (max-num &optional (min-num 0))
  (join-with-newline
    (loop for num downfrom max-num to min-num
      collect (verse num))))

(defun verse (num)
  (format nil
          "~@(~A~), ~A.~&~
          ~A, ~A.~&"
          (bottles-on-wall num)
          (bottles num)
          (action num)
          (bottles-on-wall (- num 1))))

(defun bottles-on-wall (num)
  (format nil "~A on the wall" (bottles num)))

(defun action (num)
  (case num
    (0 "Go to the store and buy some more")
    (t (action-take num))))

(defun action-take (num)
  (format nil
          "Take ~A down and pass it around"
          (case num
            (1 "it")
            (t "one"))))

(defun bottles (num)
  (format nil
          "~A bottle~P of beer"
          (number-of-bottles num)
          num))

(defun number-of-bottles (num)
  (case num
    (0 "no more")
    (-1 "99")
    (t (write-to-string num))))

(defun join-with-newline (lst)
  (format nil "~{~a~%~}" lst))
