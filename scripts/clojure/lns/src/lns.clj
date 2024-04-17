#!/usr/bin/env bb

(ns lns
  (:require [babashka.cli :as cli]
            [babashka.process :refer [shell]]
            [clojure.string :as str]))

(load-file "/home/wurfkreuz/.dotfiles/scripts/clojure/libs/path_utils.clj")
(require '[path-utils :refer [get-absolute-path get-distilled-filename file-is?]])


(defn show-help [spec]
  (let [usage "Usage: lns <files> [options <location>] \n"
        general-info "Create soft links fast\n"
        flags "Flags:\n"
        options-description (cli/format-opts (merge spec {:order (vec (keys (:spec spec)))}))]
    (str general-info usage flags options-description)))


; (def cli-spec
;   {:coerce {:l :string}})

(def cli-spec
  {:spec {:link {:coerce str 
              :desc "Specify link path"
              :alias :l}}})


; (def cli-spec
;   {:spec {:link {:coerce str
;               :desc "Specify link path"
;               :alias :l}}})

; (def cli-spec
;   {:spec
;    {:link {:coerse :string
;             :desc "Specify link path"
;             :alias :l}}})

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
          "n" (do (println "\nExiting script by user choice.\n")
                  (System/exit 0))  ; Exit the script with a status code of 0 (normal termination)
          (println "\nInvalid input. No action taken.\n"))))))

(defn link [filename linkname?]
  (let [default-link-path "/usr/local/bin"
        abs-filename (get-absolute-path filename)
        target-link-path (if linkname?
                           (str linkname? "/" (get-distilled-filename filename))
                           (str default-link-path "/" (get-distilled-filename filename)))]
    (deletion-prompt target-link-path)
    (println "\nDoing ln -s at" abs-filename "to" target-link-path)
    (shell "ln -s" abs-filename target-link-path)))

(defn process-files [filenames linkname?]
  (doseq [filename filenames]
    (link filename linkname?)))

(defn parse-args-and-link [args]
  (let [{:keys [args opts]} (cli/parse-args args cli-spec)
        linkname? (get opts :link)]
    (if (or (:help opts) (:h opts))
      (println (show-help cli-spec))
      (do (println (if linkname?
                (str "Link path is provided, linking file/files to: " linkname?)
                "Link path isn't provided linking file to: /home/wurfkreuz"))
          (process-files args linkname? )))))

(defn -main [args]
  (parse-args-and-link args))

(-main *command-line-args*)


;; /home/wurfkreuz/.secret_dotfiles/org/clojure/scripts/lns.org
