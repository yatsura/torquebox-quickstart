{
 :root (str (System/getenv "OPENSHIFT_REPO_DIR") "my-clojure-app")
 :context-path "/clojure"
 :swank-port 24005
 :nrepl-port 27888

 :lein-profiles [:openshift]
}