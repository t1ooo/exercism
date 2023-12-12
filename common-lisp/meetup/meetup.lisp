(in-package #:cl-user)
(defpackage #:meetup
  (:use #:common-lisp)
  (:export #:meetup))

(in-package #:meetup)

(defvar days '(   
  :monday       ;;  0
  :tuesday      ;;  1 
  :wednesday    ;;  2  
  :thursday     ;;  3  
  :friday       ;;  4
  :saturday     ;;  5
  :sunday))     ;;  6    

(defvar num-of-days 7)

(defun factor-of (desc-symbol)
  (ecase desc-symbol
    (:first  0)
    (:second 1)
    (:third  2)
    (:fourth 3)
    (:last   0)
    (:teenth 0)))

(defun day-of-week (day month year)
  (nth-value 6
    (decode-universal-time (encode-universal-time 0 0 0 day month year 0) 0)))

(defun increment (num step max)
  (loop while (<= (+ num step) max)
    do (setf num (+ num step)))
  num)

(defun divisiblep(a b)
  (zerop (rem a b)))

(defun leap-year-p (y)
  (or (divisiblep y 400)
      (and (divisiblep y 4)
           (not (divisiblep y 100)))))

(defun num-of-days-february (year)
  (if (leap-year-p year) 29 28))

(defun num-of-days-month  (month year)
  (case month
    (2 (num-of-days-february year))
    ((zerop (mod month 2)) 30)
    (t 31)))

(defun correct-last (day month year)
  (increment day num-of-days (num-of-days-month month year)))

(defun correct-teenth (day)
  (increment day num-of-days 19))

(defun days-diff (day1 day2)
  (mod (- day1 day2) num-of-days))

(defun meetup (month year day-symbol desc-symbol)
  (let* ((first-day 1)
         (factor (factor-of desc-symbol))
         (first-dow (day-of-week first-day month year))
         (meetup-dow (position day-symbol days))
         (dow-diff (days-diff meetup-dow first-dow))
         (day (+ (* factor num-of-days) dow-diff first-day)))
    (list year month
      (case desc-symbol
        (:last (correct-last day month year))
        (:teenth (correct-teenth day))
        (t day)))))