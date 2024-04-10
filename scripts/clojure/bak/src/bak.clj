#!/usr/bin/env bb

(ns bak
  (:require [clojure.string :as str]
            [babashka.process :refer [shell]]))

(defn is-bak? [file-name]
  (str/ends-with? file-name ".bak"))

(defn bak [file-name]
  (if (is-bak? file-name)
    (subs file-name 0 (- (count file-name) 4))
    (str file-name ".bak")))

;; what type is filename before i convert it to string?
(defn absolute-path [filename]
  (.getAbsolutePath (java.io.File. (str filename))))

(defn rename-file [filename new-filename]
  (shell "mv" filename new-filename))

(defn process-file [file-name]
  (let [absolute-file-name (absolute-path file-name)
        new-name (bak absolute-file-name)]
    (rename-file absolute-file-name new-name)
    (println "Renamed" absolute-file-name "to" new-name)))

;; Why use '&' here?
; (defn -main [& args]
(defn -main [& args]
  (doseq [arg args]
    (process-file arg)))

(apply -main *command-line-args*)


;; '(subs file-name 0 (- (count file-name) 4))'.
;; 'subs' is a shorthand for 'substring'. Substring is a smaller string that
;; exists within a larger string. So what i'm doing here is defining a substring
;; which starts from 0 index to whole filename count - 4.

