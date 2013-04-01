(ns immutant.init
  (:require [immutant.web :as web])
  (:use [ring.util.response :only [redirect]]))

(defn handler [request]
  (redirect (str (:context request) "/index.html")))

(web/start (web/wrap-resource handler "public"))
