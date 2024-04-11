#!/usr/bin/env bb

(ns bak
  (:require [clojure.string :as str]
            [babashka.cli :as cli]
            [babashka.process :refer [shell]]))

(def cli-spec
  {:spec
   {:copy {:coerce :boolean
                 :desc "Copy files instead of moving"
                 :alias :c}}
   :args->opts (cons :files (repeat :files))
   :coerce {:files []}})

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

(defn -main [args]
  (let [{:keys [copy files]} (cli/parse-opts args cli-spec)]
    (doseq [file-name files]
      (process-file file-name copy))))

(-main *command-line-args*)

;; Comments
;; {file:/home/wurfkreuz/.secret_dotfiles/org/clojure/scripts/bak/bak.org}
