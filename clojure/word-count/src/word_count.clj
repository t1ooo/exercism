(ns word-count
  (:require [clojure.string :as str]))

(defn word-count [s]
  (-> s
      (str/lower-case)
      (str/split #"[^\p{N}\p{L}]+")
      (frequencies)))
