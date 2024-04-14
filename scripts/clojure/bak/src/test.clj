(ns test)

#!/usr/bin/env bb
(require '[babashka.cli :as cli]
         '[babashka.fs :as fs])

(defn dir-exists?
  [path]
  (fs/directory? path))

(defn show-help
  [spec]
  (cli/format-opts (merge spec {:order (vec (keys (:spec spec)))})))

(def cli-spec
  {:spec
   {:num {:coerce :long
          :desc "Number of some items"
          :alias :n                     ; adds -n alias for --num
          :validate pos?                ; tests if supplied --num >0
          :require true}                ; --num,-n is required
    :dir {:desc "Directory name to do stuff"
          :alias :d
          :validate dir-exists?}        ; tests if --dir exists
    :flag {:coerce :boolean             ; defines a boolean flag
           :desc "I am just a flag"}}
   :error-fn                           ; a function to handle errors
   (fn [{:keys [spec type cause msg option] :as data}]
     (if (= :org.babashka/cli type)
       (case cause
         :require
         (println
           (format "Missing required argument: %s\n" option))
         :validate
         (println
           (format "%s does not exist!\n" msg)))))
   })

(defn -main
  [args]
  (let [opts (cli/parse-opts args cli-spec)]
    (if (or (:help opts) (:h opts))
      (println (show-help cli-spec))
      (println "Here are your cli args!:" opts))))

(-main *command-line-args*)
