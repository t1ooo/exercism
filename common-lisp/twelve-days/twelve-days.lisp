(in-package #:cl-user)
(defpackage #:twelve-days
  (:use #:cl)
  (:export #:recite))

(in-package #:twelve-days)

(defun join-with-newline (lst)
  (format nil "~{~a~^~%~}" lst))

(defun join-with-comma(lst)
  (format nil "~{~A, ~}" lst))

(defun list-slice(lst begin end)
  (loop for i from begin to (1- end)
    collect (nth i lst)))

(defvar gifts '(
  "two Turtle Doves"
  "three French Hens"
  "four Calling Birds"
  "five Gold Rings"
  "six Geese-a-Laying"
  "seven Swans-a-Swimming"
  "eight Maids-a-Milking"
  "nine Ladies Dancing"
  "ten Lords-a-Leaping"
  "eleven Pipers Piping"
  "twelve Drummers Drumming"))

(defun template(num)
  (case num
    (1 "~a~a~a")
    (otherwise "~a~aand ~a")))

(defun verse(num)
  (format nil (template num)
    (format nil "On the ~:r day of Christmas my true love gave to me: " num)
    (join-with-comma (reverse (list-slice gifts 0 (1- num))))
    "a Partridge in a Pear Tree."))

(defun song(begin end)
  (join-with-newline
    (loop for num from begin to end
      collect (verse num))))

(defun recite (&optional begin end)
  (cond 
    ((and (not begin) (not end)) 
      (song 1 12))
    ((not end) 
      (verse begin))
    (t 
      (song begin end))))
