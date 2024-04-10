#!/usr/bin/env bb

(ns bak
  (:require [clojure.string :as str]
            [babashka.cli :as cli]
            [babashka.process :refer [shell]]))

(def cli-spec
  {:spec
   {:copy {:coerce :boolean             ; defines the -c/--copy flag as a boolean
           :desc "Copy files instead of moving"
           :alias :c}}                  ; adds -c alias for --copy
   })

(defn is-bak? [file-name]
  (str/ends-with? file-name ".bak"))

(defn bak [file-name]
  (if (is-bak? file-name)
    (subs file-name 0 (- (count file-name) 4))
    (str file-name ".bak")))

;; what type is filename before i convert it to string?
(defn absolute-path [filename]
  (.getAbsolutePath (java.io.File. (str filename))))

(defn rename-file [filename new-filename copy?]
  (if copy?
    (shell "cp -r" filename new-filename)
    (shell "mv" filename new-filename)))

(defn process-file [file-name copy?]
  (let [absolute-file-name (absolute-path file-name)
        new-name (bak absolute-file-name)]
    (rename-file absolute-file-name new-name copy?)
    (println (str "Processed " absolute-file-name " to " new-name (if copy? " (copied)" " (moved)")))))  ;; 'if' works only on 2 conditional parameters.

;; Why use '&' here?
; (defn -main [& args]
(defn -main [& args]
  (let [{:keys [options args]} (cli/parse-opts args cli-spec)
        copy? (:copy options)]
    (doseq [file-name args]
      (process-file file-name copy?))))

(apply -main *command-line-args*)


;; '(subs file-name 0 (- (count file-name) 4))'.
;; 'subs' is a shorthand for 'substring'. Substring is a smaller string that
;; exists within a larger string. So what i'm doing here is defining a substring
;; which starts from 0 index to whole filename count - 4.

;; :coerce: This key is used to indicate that the parsed value of the
;; command-line argument should be coerced or converted into a specific
;; type. It's a way to automatically transform the string representation of an
;; argument into a more useful or appropriate Clojure data type.
;; So that why ':coerce' and ':boolean' are on the same line. It basically says
;; "coerse value of the '--copy' flag to boolean".
;; Why i can't just write ':boolean'? Because ':boolean' but itself doesn't do
;; anything. This approach makes the system more composable.


;; [{:keys [options args]} (cli/parse-opts args cli-spec)
;;       copy? (:copy options)]
;;
;; First of all, you have to read this code from the end of each line.
;; The 'parse-opts' function parses arguments based on scheme i defined at the
;; start, which is called 'cli-spec'.
;; The 'parse-opts' returns two maps - one with options and the other with
;; arguments. The maps can be called as you like.
;; By using ':keys' i basically give entry point names to the returned maps.
;;
;; {:options {:copy true :verbose false} :args ["file1.txt" "file2.txt"]}
;;
;; The option maps contain keys and values for each option recognized and parsed
;; by cli/parse-opts. The line copy? (:copy options) looks up the :copy key in the
;; options map and binds its value to the local variable copy?
