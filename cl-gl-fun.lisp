;;;; cl-gl-fun.lisp

(in-package #:cl-gl-fun)

(defparameter *keys-pressed* nil)

(defun update-window-title (window)
  (set-window-title (format nil "size ~A | keys ~A | buttons ~A"
                            nil
                            *keys-pressed*
                            nil)))

(def-key-callback my-key-callback (window key scancode action mod-keys)
  (declare (ignore scancode mod-keys))
  (when (and (eq key :escape) (eq action :press))
    (set-window-should-close))
  (if (eq action :press)
      (pushnew key *keys-pressed*)
      (deletef *keys-pressed* key))
  (update-window-title window))

(def-window-size-callback my-window-size-callback (window w h)
  (declare (ignore window))
  (set-viewport w h))

(defun render ()
  (gl:clear :color-buffer)
  (gl:with-pushed-matrix
      (gl:color 1 1 1 1)
    (gl:rect -25 -25 25 25)))

(defun set-viewport (width height)
  (gl:viewport 0 0 width height)
  (gl:matrix-mode :projection)
  (gl:load-identity)
  (gl:ortho -50 50 -50 50 -1 1)
  (gl:matrix-mode :modelview)
  (gl:load-identity))

(defun main ()
  (with-body-in-main-thread ()
    (sb-int:set-floating-point-modes :traps nil)
    (with-init-window (:title "" :width 400 :height 400)
      (setf %gl:*gl-get-proc-address* #'get-proc-address)
      (set-key-callback 'my-key-callback)
      (set-window-size-callback 'my-window-size-callback)
      (update-window-title *window*)
      (gl:clear-color 0 0 0 0)
      (set-viewport 400 400)
      (loop until (window-should-close-p)
            do (render)
            do (swap-buffers)
            do (poll-events)))))
;;(trivial-main-thread:call-in-main-thread
;; (lambda ()
;;   (sb-int:set-floating-point-modes :traps nil)
;;   (glfw:init)
;;   (let ((window (glfw:create-window 320 240 "test")))
;;     (glfw:make-context-current window)
;;     (loop while (not (glfw:window-should-close))
;;           do (progn
;;                () ;; How do we set clear here?
;;                (glfw:swap-buffers window)
;;                (glfw:poll-events)))))))
;;(cl-glfw3-examples:basic-window-example))))
