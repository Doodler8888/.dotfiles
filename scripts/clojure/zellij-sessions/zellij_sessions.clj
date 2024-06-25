; (ns zellij-sessions
;   (:require [babashka.process :refer [shell]]
;             [clojure.string :as str]))

; ;; Run the command and capture the output
; (let [result (shell "zellij list-sessions | awk '($1 ~ /-/) {print $1}'")
;       names  (str/split-lines (:out result))]
;   ;; Iterate over the elements of the names list
;   (doseq [name names]
;     (println (str "This is a session name: " name))))

(require '[babashka.process :refer [shell]])

(def names 
  (-> (shell {:out :string} "bash" "-c" "zellij list-sessions | awk '($1 ~ /-/) {print $1}'")
      :out
      .trim
      (.split "\n")))

(doseq [name names]
  (println (str "This is a session name: " name)))
