(in-package #:cl-user)
(defpackage #:word-count
  (:use #:cl)
  (:export #:count-words))
(in-package #:word-count)

(defun list-count-values(lst)
  (loop for val in (remove-duplicates lst :test 'string=)
    collect (cons val (count val lst :test 'string=))))

(defun map-list(func lst)
  (map 'list func lst))

(defun string-empty-p(str)
  (string= "" str))

(defun trim-apostrophe(str)
  (string-trim "'" str))

(defun valid-char-p(ch)
  (or (char= ch #\') (alphanumericp ch)))

(defun clean(str)
  (remove-if-not #'valid-char-p str))

(defun normalize(str)
  (trim-apostrophe (clean str)))

(defun split(str)
  (uiop:split-string str :separator " ,
"))

(defun count-words(sentence)
  (list-count-values
    (remove-if
      #'string-empty-p
      (map-list
        #'normalize
        (split (string-downcase sentence))))))