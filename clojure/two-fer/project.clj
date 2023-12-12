(defproject two-fer "0.1.0-SNAPSHOT"
  :description "two-fer exercise."
  :url "https://github.com/exercism/clojure/tree/master/exercises/two-fer"
  :dependencies [[org.clojure/clojure "1.10.0"],
                 [org.clojure.typed/runtime.jvm "1.0.1"]]
  :profiles {:dev {:dependencies [[org.clojure.typed/checker.jvm "1.0.1"]]}})
