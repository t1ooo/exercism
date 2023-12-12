(ns run-length-encoding)

(defn encode [[head & tail :as s]]
  (cond->> (str head)
    tail (str (count s))))

(defn run-length-encode
  "encodes a string with run-length-encoding"
  [plain-text]
  (->>
   plain-text
   (partition-by identity)
   (map encode)
   (apply str)))

(defn parse-int [s def-val]
  (if (empty? s)
    def-val
    (Integer/parseInt s)))

(defn decode [[_ count ch]]
  (->>
   (repeat ch)
   (take (parse-int count 1))
   (apply str)))

(defn run-length-decode
  "decodes a run-length-encoded string"
  [cipher-text]
  (->>
   cipher-text
   (re-seq #"(\d*)(\D)")
   (map decode)
   (apply str)))
