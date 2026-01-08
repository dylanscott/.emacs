;;; Startup optimizations

;; Temporarily increase the garbage collection threshold
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)
(add-hook 'emacs-startup-hook
          (lambda ()
            ;; Restore to defaults (or close to them)
            (setq gc-cons-threshold (* 1024 1024)
                  gc-cons-percentage 0.1)))

;;; UI defaults
(setq initial-frame-alist '((width . 180) (height . 60))
      default-frame-alist '((width . 180) (height . 60))
      frame-resize-pixelwise t
      frame-inhibit-implied-resize 'force
      window-resize-pixelwise t
      use-file-dialog nil
      use-short-answers t
      inhibit-splash-screen t
      inhibit-startup-screen t
      inhibit-x-resources t
      inhibit-startup-echo-area-message user-login-name
      inhibit-startup-buffer-menu t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
