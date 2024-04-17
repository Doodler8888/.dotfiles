(ns path-utils
  (:require [clojure.java.io :as io]
            [babashka.fs :as fs]))

(defn get-absolute-path [filename]
  (let [file (io/file (str filename))]
    (if (.exists file)
      (.getAbsolutePath file)
      (throw (java.io.FileNotFoundException. (str "File does not exist: " filename))))))

(defn get-filename 
  "Meant to used only on absolute paths (?)"
  [path]
  (.getName (java.io.File. path)))

(defn get-distilled-filename 
  "Get filename from incomplete path"
  [filename]
  (get-filename(get-absolute-path filename)))

(defn file-is? [path]
  (let [p (fs/path path)]  ;; 'p' is just a binding for representing path
    (cond
      (not (fs/exists? p)) {:status :does-not-exist}
      (fs/directory? p) {:status :directory}
      (fs/sym-link? p) {:status :symbolic-link}
      (fs/regular-file? p) {:status :regular-file}
      :else {:status :other})))
