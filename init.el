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

(add-to-list 'auto-mode-alist '("\\.svg\\'" . nxml-mode))

(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))
(setq lock-file-name-transforms '(("\\`/.*/\\([^/]+\\)\\'" "~/.emacs.d/aux/\\1" t)))
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))
(setq custom-file "/dev/null") ; don't use customize

;;; Shell
(setq explicit-shell-file-name "/bin/zsh")
(setq shell-file-name "zsh")
(setq explicit-zsh-args '("--login" "--interactive"))
(defun zsh-shell-mode-setup ()
  (setq-local comint-process-echoes t))
(add-hook 'shell-mode-hook #'zsh-shell-mode-setup)

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

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :config
  ;; run shell non-interactively for performance
  ;; note: this means .zshrc is not evaluated, only .zshenv and .zprofile
  (setq exec-path-from-shell-arguments nil)
  (exec-path-from-shell-initialize))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package magit)

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
  (keymap-unset evil-normal-state-map "C-.")
  (keymap-unset evil-normal-state-map "g") ; these are weird
  ;; disable scrolling keybindings
  (keymap-unset evil-normal-state-map "z")
  (keymap-unset evil-motion-state-map "z")
  ;; navigate/search by symbol
  (defalias #'forward-evil-word #'forward-evil-symbol)
  (setq-default evil-symbol-word-search t))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

;;;; Keybindings
(use-package general
  :config
  (general-auto-unbind-keys)
  (general-evil-setup t)

  ;;;;; evil states
  (general-define-key
   :states 'motion
   "gb" '(pop-global-mark :whick-key)
   "C-h" '(evil-window-left :which-key)
   "C-j" '(evil-window-down :which-key)
   "C-k" '(evil-window-up :which-key)
   "C-l" '(evil-window-right :which-key))

  ;;;;; leader prefixed
  (general-create-definer leader
    :prefix "SPC")
  (leader
    :states '(motion normal visual)
    :keymaps 'override

    "x" '(execute-extended-command :which-key "execute-extended-command")
    "X" '(execute-extended-command-for-buffer :which-key "execute-extended-command-for-buffer")
    "u" '(universal-argument :which-key "universal-argument")

    ;;;;;; eval
    "e"  '(:ignore t :which-key "eval")
    "eb" '(eval-buffer :which-key "buffer")
    "ee" '(eval-expression :which-key "expression")
    "ef" '(eval-defun :which-key "defun")
    "er" '(eval-region :which-key "region")
    "es" '(eval-last-sexp :which-key "last-sexp")

    ;;;;;; describe
    "?"  '(:ignore t :which-key "describe")
    "?b" '(embark-bindings :which-key "bindings")
    "?c" '(describe-command :which-key "command")
    "?d" '(eldoc :which-key "eldoc")
    "?f" '(describe-function :which-key "function")
    "?k" '(describe-key :which-key "key")
    "?m" '(describe-mode :which-key "mode")
    "?p" '(describe-package :which-key "package")
    "?v" '(describe-variable :which-key "variable")

    ;;;;;; refactor
    "r"  '(:ignore t :whick-key "refactor")
    "rn" '(eglot-rename :which-key "rename symbol")

    ;;;;;; consult
    "c"  '(:ignore t :which-key "consult")
    "cb" '(consult-buffer :which-key "buffer")
    "cg" '(consult-ripgrep :which-key "grep")
    "cm" '(consult-mark :which-key "mark")
    "cM" '(consult-global-mark :which-key "global-mark")
    "cp" '(consult-ls-git-ls-files :which-key "files")
    "cP" '(consult-ls-git-ls-files-other-window :which-key "files-other-window")
    "cy" '(consult-yank-from-kill-ring :which-key "yank")
    "cy" '(consult-yank-pop :which-key "yank-pop")
    "c/" '(consult-line :which-key "line")))

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

;;;; Completion
(use-package vertico
  :custom
  (vertico-cycle t)
  (read-buffer-completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (completion-styles '(basic substring partial-completion flex))
  :hook
  ('rfn-eshadow-update-overlay . vertico-directory-tidy)
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous))
  :init
  (vertico-mode))

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  :init
  (global-corfu-mode))

(use-package consult
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  (setq consult-narrow-key "<"))

(use-package consult-project-extra)

(use-package consult-ls-git)

(use-package consult-eglot)

(use-package marginalia
  :init
  (marginalia-mode))

(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;;;; Tree-sitter
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;;;; Eglot
(use-package eglot
  :hook ((rust-mode rust-ts-mode typescript-ts-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs '(typescript-ts-mode . ("tsgo" "--lsp" "--stdio"))))

(use-package rust-mode
  :init
  (setq rust-mode-treesitter-derive t))
