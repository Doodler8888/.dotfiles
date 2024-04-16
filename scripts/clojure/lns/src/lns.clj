#!/usr/bin/env bb

(ns lns
  (:require [babashka.cli :as cli]
            [babashka.process :refer [shell]]
            [babashka.fs :as fs]
            [clojure.string :as str]))

(load-file "/home/wurfkreuz/.dotfiles/scripts/clojure/libs/path_utils.clj")
(require '[path-utils :refer [get-absolute-path get-distilled-filename]])


(def cli-spec
  {:coerce {:l :string}})

; (defn deletion-prompt [filename]
;   (if file-exists (get-absolute-path filename)
;     ))

(defn file-is? [path]
  (let [p (fs/path path)]
    (cond
      (not (fs/exists? p)) {:status :does-not-exist}
      (fs/directory? p) {:status :directory}
      (fs/sym-link? p) {:status :symbolic-link}
      (fs/regular-file? p) {:status :regular-file}
      :else {:status :other})))

(defn deletion-prompt [path]
  (let [file-status (file-is? path)]
    (when (not= (:status file-status) :does-not-exist)
      (println (case (:status file-status)
                 :symbolic-link (str "\nThe " path " already exists and it's a link.")
                 :regular-file (str "\nThe " path " already exists.")
                 :directory (str "\nThe " path " already exists and it's a directory.")
                 "\nThe path exists but is not a regular file or a symbolic link."))
      (println "\nDo you want to delete it?\n\nType y/n\n")
      (let [response (clojure.string/trim (read-line))]
        (case response
          "y" (case (:status file-status)
                    :symbolic-link (do (shell "rm" path)
                                       (println "Link deleted."))
                    :regular-file (do (shell "rm" path)
                                      (println "File deleted."))
                    :directory (do (shell "rm" "-ri" path)
                                   (println "Directory deleted.")))
          "n" (println "\nExiting script by user choice.\n")
          (println "\nInvalid input. No action taken.\n"))))))

(defn link [filename linkname?]
  (let [default-link-path "/usr/local/bin"
        abs-filename (get-absolute-path filename)
        target-link-path (if linkname?
                           (str linkname? "/" (get-distilled-filename filename))
                           default-link-path)]
    (deletion-prompt target-link-path)
    (println "\nDoing ln -s to" abs-filename "at" target-link-path)
    (shell "ln -s" abs-filename target-link-path)))

(defn process-files [filenames linkname?]
  (doseq [filename filenames]
    (link filename linkname?)))

(defn parse-args-and-link [args]
  (let [{:keys [args opts]} (cli/parse-args args cli-spec)
        linkname? (get opts :l)]
    (println (if linkname?
               (str "Link path is provided, linking file/files to: " linkname?)
               "Link path isn't provided linking file to: /home/wurfkreuz"))
    (process-files args (or linkname? "/home/wurfkreuz"))))

(defn -main [args]
  (parse-args-and-link args))

(-main *command-line-args*)


;; /home/wurfkreuz/.secret_dotfiles/org/clojure/scripts/lns.org
