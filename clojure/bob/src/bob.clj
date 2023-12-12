(ns bob
  (:require [clojure.string :as str]))

(defn question? [s]
  (str/ends-with? s "?"))

(defn yell? [s]
  (and
   (= s (str/upper-case s))
   (not= s (str/lower-case s))))

(defn normalize [s]
  (str/trim s))

(defn response-for [s]
  (let [s (normalize s)]
    (cond
      (empty? s) "Fine. Be that way!"
      (and (question? s) (yell? s)) "Calm down, I know what I'm doing!"
      (question? s) "Sure."
      (yell? s) "Whoa, chill out!"
      :else "Whatever.")))
