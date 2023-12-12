(ns isbn-verifier
  (:require [clojure.string :as str]))

(defn isbn? [isbn]
  (->>
   (str/replace isbn "-" "")
   (re-matches #"^\d{9}[\dX]$")
   (map #(if (= % \X) 10 (Character/digit % 10)))
   (map * (range 10 0 -1))
   (apply +)
   (#(and (not= % 0) (= (mod % 11) 0)))))
