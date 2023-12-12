(ns say
  (:require [clojure.string :as str]))

(def data-1-19
  [""
   "one"
   "two"
   "three"
   "four"
   "five"
   "six"
   "seven"
   "eight"
   "nine"
   "ten"
   "eleven"
   "twelve"
   "thirteen"
   "fourteen"
   "fifteen"
   "sixteen"
   "seventeen"
   "eighteen"
   "nineteen"])

(def data-20-90
  [""
   ""
   "twenty"
   "thirty"
   "forty"
   "fifty"
   "sixty"
   "seventy"
   "eighty"
   "ninety"])

(def data-1000
  [""
   "thousand"
   "million"
   "billion"])

(defn thousands [n]
  (->> n
       (iterate #(quot % 1000))
       (take-while #(pos? %))
       (map #(rem % 1000))))

(defn convert-1000 [thousand n]
  (let [dv (quot n 100), rm (rem n 100), dv10 (quot rm 10), rm10 (rem rm 10)]
    (cond-> []
      (pos? dv)                    (conj (data-1-19 dv) "hundred")
      (>= rm 20)                   (conj (data-20-90 dv10))
      (and (>= rm 20) (pos? rm10)) (conj "-" (data-1-19 rm10))
      (<= rm 19)                   (conj (data-1-19 rm))
      (pos? n)                     (conj thousand))))

(defn convert [n]
  (if (zero? n)
    "zero"
    (->> n
         (thousands)
         (map convert-1000 data-1000)
         (reverse)
         (flatten)
         (str/join " ")
         (#(str/replace % " - " "-"))
         (str/trimr))))

(defn number [n]
  (when-not (<= 0 n 999999999999)
    (throw (new IllegalArgumentException)))
  (convert n))
