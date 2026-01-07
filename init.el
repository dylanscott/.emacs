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

;;;; Keybindings
(use-package general
  :config
  (general-auto-unbind-keys)
  (general-evil-setup t)

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
    "e" '(:ignore t :which-key "eval")
    "eb" '(eval-buffer :which-key "eval-buffer")
    "ee" '(eval-expression :which-key "eval-expression")
    "ef" '(eval-defun :which-key "eval-defun")
    "er" '(eval-region :which-key "eval-region")
    "es" '(eval-last-sexp :which-key "eval-last-sexp")

    ;;;;;; describe
    "?" '(:ignore t :which-key "describe")
    "?c" '(describe-command :which-key "describe-command")
    "?f" '(describe-function :which-key "describe-function")
    "?k" '(describe-key :which-key "describe-key")
    "?m" '(describe-mode :which-key "describe-mode")
    "?p" '(describe-package :which-key "describe-package")
    "?v" '(describe-variable :which-key "describe-variable")

    ;;;;;; refactor
    "r" '(:ignore t :whick-key "refactor")
    "rn" '(eglot-rename :which-key "rename symbol")

    ;;;;;; consult
    "c" '(:ignore t :which-key "consult")
    "cb" '(consult-buffer :which-key "consult-buffer")
    "cp" '(consult-ls-git-ls-files :which-key "Find file in project")
    "cP" '(consult-ls-git-ls-files-other-window :which-key "Find file in project (other window)")
    "cm" '(consult-global-mark :which-key "consult-global-mark")
    "cM" '(consult-mark :which-key "consult-mark"))

   ;;;;; normal mode
   (general-define-key
    :states '(normal visual)

    ;;;;;; nagivation
    "g" '(:ignore t :which-key "navigate")
    "gr" '(xref-find-references :which-key "Find references")
    "gd" '(xref-find-definitions :which-key "Find definition(s)"))

   ;;;;; insert mode
   (general-define-key
    :states 'insert

    "C-SPC" 'completion-at-point
    "M-v" 'yank)

   (general-define-key
    :keymaps 'evil-ex-search-keymap
    "M-v" 'yank)

   (general-define-key
    "M-v" 'yank))

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

(use-package consult-ls-git
  :bind
  (("C-c g f" . #'consult-ls-git)
   ("C-c g F" . #'consult-ls-git-other-window)))

(use-package consult-eglot)

(use-package marginalia
  :init
  (marginalia-mode))

(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("M-." . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc.  You may adjust the Eldoc
  ;; strategy, if you want to see the documentation from multiple providers.
  (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

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
  :hook ((rust-mode rust-ts-mode) . eglot-ensure))

(use-package rust-mode
  :init
  (setq rust-mode-treesitter-derive t))
