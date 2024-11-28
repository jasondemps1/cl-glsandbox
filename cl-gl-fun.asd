;;;; cl-gl-fun.asd

(asdf:defsystem #:cl-gl-fun
  :description "Describe cl-gl-fun here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (:cl-glfw3
               :cl-opengl
               :alexandria
               :trivial-main-thread)
  :components ((:file "package")
               (:file "cl-gl-fun")))
