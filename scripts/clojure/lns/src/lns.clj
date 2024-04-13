#!/usr/bin/env bb

(ns lns
  (:require [clojure.string :as str]
            [babashka.cli :as cli]
            [clojure.java.io :as io]
            [babashka.process :refer [shell]]))

(load-file "/home/wurfkreuz/.dotfiles/scripts/clojure/libs/path_utils.clj")
(require '[path-utils :refer [get-absolute-path get-filename get-distilled-filename]])

; (def cli-spec
;   {:spec
;    {:link {:coerce :boolean
;                  :desc "Specify link destination"
;                  :alias :l}}
;    :args->opts [:path]})

(def cli-spec
  {:coerce {:l :string}})

(defn link [filename linkname?]
  ; (let [default-link-path "/usr/local/bin/"
    (let [default-link-path "/home/wurfkreuz/"
          abs-filename (get-absolute-path filename)]
        ; (println "This is a filename: " filename)
        ; (println "This is a linkname: " linkname?)
        ; (println "This is a defualt-linkname: " default-link-path)
      (if linkname?
        (shell "ln -s" abs-filename linkname?)
        (shell "ln -s" abs-filename default-link-path))))

(defn parse-args-and-link [args]
  (let [{:keys [args opts]} (cli/parse-args args cli-spec)]  ;; Don't miss that ':keys [args opts]' the part 'args' comes from the parsing, it's not the same main function argument.
    (if-let [linkname (get opts :l)]
      ;; If -l is provided, link the files to the specified path
      (do (println "Linking file to:" linkname)
          (doseq [filename args] ; Assuming all positional args are filenames
            (println "doing ln -s to" (get-absolute-path filename) (str linkname "/" (get-distilled-filename filename)))
            (shell "ln -s" (get-absolute-path filename) (str linkname "/" (get-distilled-filename filename)))))
      ;; If -l is not provided, handle accordingly
      (println "No link destination specified, handling files:" args))))

(defn -main [args]
  (let [{:keys [files link path]} (cli/parse-opts args cli-spec)]
  (let [filename (first args)
        linkname? (second args)] ; This will be nil if not provided
    (link filename linkname?))))

(-main *command-line-args*)


;; I can't pass filename and linkname as parameters directly into the main
;; function. It's probably comes from the fact that even though i defined the
;; main function with one parameter, it comes as a list thanks to
;; *command-line-args*, so i have the ability to destructure it. But if i would
;; define two parameters, that would mean the main function needs two lists and
;; passing only one literal parameter in the shell doesn't make possible to
;; create the second list in conjunction with *command-line-args*.
;; I don't think that my explanation is technically correct but the essence of
;; it should.
