;; path_utils.clj
(ns path-utils
  (:require [clojure.java.io :as io]))

(defn absolute-path [filename]
  (.getAbsolutePath (io/file (str filename))))
