;; -*- lexical-binding: t -*-

;;; Startup optimizations

;; Temporarily increase the garbage collection threshold
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)
(add-hook 'emacs-startup-hook
          (lambda ()
            ;; Restore to defaults (or close to them)
            (setq gc-cons-threshold (* 1024 1024)
                  gc-cons-percentage 0.1)))
