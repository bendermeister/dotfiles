;; Emacs Configuratoin
;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; General Emacs settings
(setq inhibit-startup-screen t)       ;; Disable the startup screen
(setq initial-scratch-message nil)    ;; Remove initial message
(tool-bar-mode -1)                    ;; Disable the toolbar
(scroll-bar-mode -1)                  ;; Disable the scrollbar
(set-fringe-mode -1)
(menu-bar-mode -1)                    ;; Disable the menu bar
(setq ring-bell-function 'ignore)     ;; Disable the bell
(setq use-dialog-box nil)             ;; Disable dialog boxes
(column-number-mode t)                ;; Show column numbers
(global-display-line-numbers-mode t)  ;; Enable line numbers globally
(setq display-line-numbers-type 'relative) ;; Relative line numbers
(setq-default indent-tabs-mode nil)   ;; Use spaces instead of tabs
(setq-default tab-width 4)            ;; Set tab width to 4
;;(setq c-basic-offset 4)               ;; Set C/C++ indentation to 4 spaces
(setq make-backup-files nil)          ;; Disable backup files
(setq auto-save-default nil)          ;; Disable auto-save
(setq select-enable-clipboard t)      ;; Use system clipboard
;;(defalias 'yes-or-no-p 'y-or-n-p)     ;; Use 'y' or 'n' instead of 'yes' or 'no'
(setq-default cursor-type 'bar)       ;; Set cursor to bar
;;(set-frame-font "Caskaydia Mono Nerd Font-12" nil t)
;;(set-face-attribute 'default nil :height 130)
(setq frame-resize-pixelwise t)

;; Which-key for discovering keybindings
(use-package which-key
  :config
  (which-key-mode))

;; EVIL Mode
(use-package evil
  :init
  (setq evil-want-integration t)  ;; Necessary for evil-collection
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

;; Enhance Evil mode with more keybindings
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package mood-line
  :ensure t
  :init
  (mood-line-mode))

;; TODO: customize some more words not just TODO
(use-package hl-todo
  :ensure t
  :init
  (hl-todo-mode))

;; PDF support
(use-package pdf-tools)

;; Provides better: find-file M-x ...
(use-package vertico
  :ensure t
  :bind (:map vertico-map
         ("C-j" . vertico-next)
         ("C-k" . vertico-previous)
         ("C-l" . vertico-insert)
         ;;("C-f" . vertico-exit)
         :map minibuffer-local-map
         ("C-h" . backward-kill-word))
  :custom
  (vertico-cycle t)
  (vertico-count 20)
  :init
  (vertico-mode))

(use-package corfu
  :bind (:map corfu-map
         ("C-j" . corfu-next)
         ("C-k" . corfu-previous)
         ("C-l" . corfu-insert)
         :map minibuffer-local-map
         ("C-h" . backward-kill-word))
  :custom
  (corfu-cycle t)
  :init
  (global-corfu-mode))

;; Nice search functions
(use-package consult)

;; Saves emacs history to file
(use-package savehist
  :init
  (savehist-mode))

;; Vertico's recommended ordering
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; Moving lines up and down (bound to C-j C-k in visual mode)
(use-package drag-stuff)

;; Provides useful annotations
(use-package marginalia
  :init
  (marginalia-mode))

;; Org
(use-package org
  :config
  (setq org-directory "~/Org/")
  (setq org-agenda-files (list "birthday.org" "inbox.org" "agenda.org"))

  (setq org-todo-keywords '((sequence "TODO(t)" "STARTED(s)" "WAIT(w)" "HOLD(h)" "NOTE(n)" "MEET(M)" "|" "CANCEL(c)" "DONE(d)" "MOVED(m)")
                            (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")
                            (sequence "|" "OKAY(o)" "YES(y)" "NO(n)")))
  (setq org-capture-templates
        '(("i" "Inbox" entry (file "inbox.org") "* TODO %?\n"))))

(use-package org-fragtog
  :after org
  :hook (org-mode . org-fragtog-mode))

(use-package speed-type)

(use-package ledger-mode)

;; Projectile
(use-package projectile)
(use-package consult-projectile)

(use-package company)

;;(evil-set-initial-state 'org-agenda-mode 'normal)
(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; Needed for most themes
(use-package autothemer)
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t    
        doom-themes-enable-italic t)
  (doom-themes-org-config))

(load-theme 'doom-bluloco-light t)

;; Tree Sitter
(use-package tree-sitter
  :init
  (global-tree-sitter-mode))
(use-package tree-sitter-langs)

;; Notmuch
(use-package notmuch
  :config
  (setq notmuch-identities '("ben@wernicke.at"))
  (setq notmuch-address-command 'internal))

;; General Mail configuartion
(setq sendmail-program (executable-find "msmtp"))
(setq send-mail-function 'sendmail-send-it)
(setq mail-setup-with-from t)
(setq mail-specify-envelope-from t)
(setq message-sendmail-envelope-from 'header)
(setq mail-envelope-from 'header)

;; I USE ZSH GODAMIT
(setq explicit-shell-file-name (executable-find "zsh"))

(use-package general
  :config
  (general-evil-setup t)

  (general-create-definer my:leader-maps
    :states '(normal visual motion emacs)
    :prefix "SPC")
  (general-define-key
   :state 'visual
   "J" drag-stuff-down
   "K" drag-stuff-up))

(my:leader-maps
 ;; Buffer
 "b" '(:ignore t :which-key "Buffer")
 "bb" '(switch-to-buffer :which-key "Switch")
 "bk" '(kill-buffer :which-key "Kill")

 ;; Files
 "." 'find-file

 ;; Projectile
 "p" '(:ignore t :which-key "Project")
 "pm" '(projectile-mode :which-key "Mode")
 "pf" '(consult-projectile-find-file :which-key "File")
 "pb" '(consult-projectile-switch-to-buffer :which-key "Buffer")

 ;; Org
 "o" '(:ignore t :which-key "Org")
 "oa" '(:ignore t :which-key "Agenda")
 "oac" '(org-capture :which-key "Capture")
 "oaa" '(org-agenda :which-key "Agenda")
 "or" '(:ignore t :which-key "Roam")
 "orf" '(org-roam-node-find :which-key "Find")
 "ori" '(org-roam-node-insert :which-key "Insert")
 "ort" '(org-roam-buffer-toggle :which-key "Toggle")

 ;; Code
 "c" '(:ignore t :which-key "Code")
 "cl" '(consult-line :which-key "Consult Line")
 "cc" '(comment-or-uncomment-region :which-key "Comment")

 ;; LSP
 ;; "l"   '(:ignore t :which-key "LSP")
 ;; "lm"  '(lsp-mode :which-key "mode")
 ;; "lf"  '(:ingore t :which-key "find")
 ;; "lfr" '(lsp-find-references :which-key "references")
 ;; "lfd" '(lsp-find-references :which-key "definition")
 ;; "lfi" '(lsp-find-references :which-key "implementation")
 ;; "lft" '(lsp-find-references :which-key "type definition")
 ;; "ld"  '(:ignore t :which-key "doc")
 ;; "lds" '(lsp-ui-doc-show :which-key "show")
 ;; "ldff" '(lsp-ui-doc-focus-frame :which-key "focus")
 ;; "ldfu" '(lsp-ui-doc-unfocus-frame :which-key "focus")
 ;; "ldh" '(lsp-ui-doc-hide :which-key "focus")

 ;; Notmuch
 "n" '(:ignore t :which-key "Notmuch")
 "ns" '(:ignore t :which-key "search")
 "nss" '(notmuch-search :which-key "search")
 "nst" '(notmuch-search-by-tag :which-key "search")
 "nc" '(notmuch-mua-mail :which-key "compose")
 "nr" '(notmuch-show-reply :which-key "reply")
 "nf" '(notmuch-show-forward-message :which-key "forward"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(mood-line hl-todo corfu evil-org which-key vertico org-fragtog orderless no-littering marginalia general evil-collection drag-stuff consult-projectile)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
