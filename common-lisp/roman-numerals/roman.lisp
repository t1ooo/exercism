(defpackage #:roman
  (:use #:cl)
  (:export #:romanize))

(in-package #:roman)

; solution for cheaters
; (defun romanize(num)
  ; (format nil "~@R" num))
  
(defvar rom-arab-nums '(("M"  1000)
                        ("CM" 900)
                        ("D"  500)
                        ("CD" 400)
                        ("C"  100)
                        ("XC" 90)
                        ("L"  50)
                        ("XL" 40)
                        ("X"  10)
                        ("IX" 9)
                        ("V"  5)
                        ("IV" 4)
                        ("I"  1)))

(defun string-repeat(str num)
  (format nil "~V@{~A~:*~}" num str))

(defun list-join(lst)
  (format nil "~{~A~}" lst))

(defun romanize(num)
  (loop for (rom arab) in rom-arab-nums
        for div = (floor num arab) ; integer division
        for n = (* arab div)
        if (< 0 div)
          collect (string-repeat rom div) into res
          and do (decf num n)
        finally (return (list-join res))))