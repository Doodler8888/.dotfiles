;; path_utils.clj
(ns path-utils
  (:require [clojure.java.io :as io]))

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
