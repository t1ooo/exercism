(ns armstrong-numbers)

(defn pow [base exp]
  (apply * (repeat exp base)))

(defn num-to-digits [num]
  (->>
   num
   (iterate #(quot % 10))
   (take-while #(pos? %))
   (map #(rem % 10))))

(defn sum [num]
  (let [digits (num-to-digits num)
        len (count digits)]
    (apply + (map #(pow %1 len) digits))))

(defn armstrong? [num]
  (= num (sum num)))
