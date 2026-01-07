;; -*- lexical-binding: t -*-

;;; Adjust defaults
(setq mac-option-modifier 'meta
      uniquify-buffer-name-style 'forward
      load-prefer-newer t
      backup-by-copying t
      delete-by-moving-to-trash t
      dired-dwim-target t
      file-name-shadow-mode 1)
(setq-default indent-tabs-mode nil) ; spaces not tabs
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;;;; Modes
(global-auto-revert-mode t) ; sync buffers with changes on disk
(electric-pair-mode t) ; insert closing delimiters
(show-paren-mode 1) ; highlight matching delimiters

;; save history, cursor position
(recentf-mode t)
(savehist-mode t)
(save-place-mode t)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;;; $PATH
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

;;; PGP
(setq epa-file-select-keys nil)
(setq epa-pinentry-mode 'loopback)

;;; Packages
(setopt package-archives
	'(("melpa-stable" . "https://stable.melpa.org/packages/")
	  ("melpa" . "https://melpa.org/packages/")
          ("gnu" . "https://elpa.gnu.org/packages/")))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

;;;; Org
(use-package org
  :custom
  (org-startup-indented t)
  (org-bookmark-names-plist '())
  (org-capture-templates
   '(("j" "journal entry" plain (file+olp+datetree "~/Dropbox/journal.org.gpg")
      "%<%I:%M %p>"
      :empty-lines-after 1
      :immediate-finish t
      :jump-to-captured t
      :no-save t))))

;;;; Evil
(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit)
         :map evil-insert-state-map
         ("C-k" . nil)
         ("C-." . nil))
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  :config
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "C-.") nil))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

;;;; Theme
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-spacegrey t)
  (doom-themes-visual-bell-config) ; enable flashing mode-line on errors
  (doom-themes-org-config))

(use-package olivetti
  :hook
  (org-mode . olivetti-mode)
  :config
  (setq olivetti-body-width 88))

;;;; Tree-sitter
(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (racket "https://github.com/6cdh/tree-sitter-racket")
     (rust "https://github.com/tree-sitter/tree-sitter-rust")
     (scheme "https://github.com/6cdh/tree-sitter-scheme")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (wasm "https://github.com/wasm-lsp/tree-sitter-wasm")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(use-package treesit-auto
  :config
  (setq treesit-auto-install t)
  (global-treesit-auto-mode))
