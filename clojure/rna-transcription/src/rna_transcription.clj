(ns rna-transcription)

(defn to-rna [dna]
  (let [rna (keep {\G \C, \C \G, \T \A, \A \U} dna)]
    (assert (= (count rna) (count dna)))
    (apply str rna)))
