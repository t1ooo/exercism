(ns two-fer
  (:require [clojure.spec.alpha :as s]))

(defn two-fer
  ([] (two-fer "you"))
  ([name]
   {:pre [(s/valid? str name)]}
   (format "One for %s, one for me." name)))
