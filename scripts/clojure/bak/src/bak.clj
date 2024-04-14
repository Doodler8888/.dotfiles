#!/usr/bin/env bb

(ns bak
  (:require [clojure.string :as str]
            [babashka.cli :as cli]
            [babashka.process :refer [shell]]))

(load-file "/home/wurfkreuz/.dotfiles/scripts/clojure/libs/path_utils.clj")
(require '[path-utils :refer [get-absolute-path]])

(defn show-help [spec]
  (let [usage "Usage: bak [options] <files>\n"
        flags "Flags:\n"
        options-description (cli/format-opts (merge spec {:order (vec (keys (:spec spec)))}))]
    (str usage flags options-description)))

(def cli-spec
  {:spec
   {:copy {:coerce :boolean
                 :desc "Copy files instead of moving them"
                 :alias :c}}
   :args->opts (cons :files (repeat :files))
   :coerce {:files []}})

(defn is-bak? [file-name]
  (str/ends-with? file-name ".bak"))

(defn bak [file-name]
  (if (is-bak? file-name)
    (subs file-name 0 (- (count file-name) 4))
    (str file-name ".bak")))

(defn rename-file [filename new-filename copy?]
  (if copy?
    (shell "cp -r" filename new-filename)
    (shell "mv" filename new-filename)))

(defn process-file [file-name copy?]
  (let [absolute-file-name (get-absolute-path file-name)
        new-name (bak absolute-file-name)]
    (rename-file absolute-file-name new-name copy?)
    (println (str "Processed " absolute-file-name " to " new-name (if copy? " (copied)" " (moved)")))))  ;; 'if' works only on 2 conditional parameters.

(defn -main [args]
  (let [opts (cli/parse-opts args cli-spec)]
    (if (or (:help opts) (:h opts))
      ;; If --help or -h is present, show the help message.
      (println (show-help cli-spec))
      ;; Otherwise, proceed with the script's normal operations.
      (let [{:keys [copy files]} opts]
        (doseq [file-name files]
          (process-file file-name copy))))))

(-main *command-line-args*)

;; {file:/home/wurfkreuz/.secret_dotfiles/org/clojure/scripts/bak/bak.org}
