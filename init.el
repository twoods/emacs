;; Basic load path and custom settings setup
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp")
(add-to-list 'load-path "~/.emacs.d/lisp")
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file t)

;; Add package sources
(package-initialize)

;; Allow local customization of package archives
(require 'local-packages nil t)

;; Add default melpa and org archives if not customized
(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
(unless (assoc-default "org" package-archives)
  (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t))

;; On first load, fetch package lists
(when (not package-archive-contents)
  (package-refresh-contents))

;; Set up use package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)
(setq use-package-always-defer t)
(require 'use-package)

;; autocompile elisp files
(use-package auto-compile
             :defer nil
             :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)

;; Put backups in emacs directory, not inline
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; Turn off toolbar
(tool-bar-mode -1)

;; Pixel scroll mode - TODO try this and see if it works well
(when (>= emacs-major-version 26)
  (pixel-scroll-mode))

;; Use y/n prompts
(fset 'yes-or-no-p 'y-or-n-p)

;; Paste text at cursor
(setq mouse-yank-at-point t)

;; Highlight trailing whitespace
(setq-default show-trailing-whitespace t)

;; Default to indent with spaces
(setq-default indent-tabs-mode nil)

;; Themes
;; (use-package gruvbox-theme)
;; (load-theme 'gruvbox)
;; (use-package zenburn-theme)
;; (load-theme 'zenburn)
(load-theme 'tsdh-dark)

;; Use bind-key (comes with use-package) for binding keys
;; Can use describe-personal-keybindings to see all custom keys
(require 'bind-key)

;; Use hippie expand for completions
(bind-key "M-/" 'hippie-expand)

;; Delete trailing whitespace on save
;; TODO: Look for "smart" version
;; (add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Line numbers
(when (>= emacs-major-version 26)
  (use-package display-line-numbers
               :disabled
               :defer nil
               :ensure nil
               :config
               (global-display-line-numbers-mode)))

;; Window configuration undo/redo C-<left>/C-<right>
(use-package winner
             :defer t)

;; Save position if files
(use-package saveplace
             :defer nil
             :config
             (save-place-mode))

;; imenu bookmarks, nav by function names, headers, etc.
(use-package imenu-anywhere
             :bind
             ("M-i" . ivy-imenu-anywhere))

;; Switch windows by key
(use-package switch-window
             :disabled
             :bind
             ("C-x o" . switch-window))

;; TODO: Look at yasnippet and yankpad

;; Modeline cleanup
(use-package diminish)

;; flx/smex for better ivy matching
(use-package flx)
(use-package smex)

;; Ivy for completion
(use-package ivy
             :defer nil
             :diminish (ivy-mode . "")
             :bind
             (:map ivy-mode-map
                   ("C-'" . ivy-avy))
             :config
             (ivy-mode 1)
             ;; add 'recenttf-mode' and bookmarks to 'ivy-switch-buffer'
             (setq ivy-use-virtual-buffers t)
             ;; number of result lines to display
             (setq ivy-height 10)
             ;; does not count candidates
             (setq ivy-count-format "")
             ;; no regexp by default
             (setq ivy-initial-inputs-alist nil)
             ;; configure regexp engine
             (setq ivy-re-builders-alist
                   ;; allow input not in order
                   ;; '((t . ivy--regex-ignore-order))
                   '((t . ivy--regex-fuzzy))
                   ))

;; Swiper for search
;; TODO: Try this out vs standard search
;; (bind-key "C-s" 'swiper)

;; Counsel for more ivy goodness
;; TODO: counsel-mode might be overkill, look at ivy recommended settings
;;       Some example bindings (not from ivy site) below
(use-package counsel
             :defer nil
             :diminish (counsel-mode . "")
             :config
             ;; :bind
             ;; (("C-x C-f" . counsel-find-file)
             ;;  ("C-h f" . counsel-describe-function)
             ;;  ("C-h v" . counsel-describe-variable)
             ;;  ("M-y" . counsel-yank-pop))
             (counsel-mode 1))

;; Try counsel for tags
(use-package counsel-etags
  :defer t
  :init
  ;; Don't ask before rereading the TAGS files if they have changed
  (setq tags-revert-without-query t)
  ;; Don't warn when TAGS files are large
  (setq large-file-warning-threshold nil)
  :config
  (progn
    ;; counsel-etags-ignore-directories does NOT support wildcast
    (add-to-list 'counsel-etags-ignore-directories "build_clang")
    (add-to-list 'counsel-etags-ignore-directories "build_clang")
    ;; counsel-etags-ignore-filenames supports wildcast
    (add-to-list 'counsel-etags-ignore-filenames "TAGS")
    (add-to-list 'counsel-etags-ignore-filenames "*.json"))
  ;; Setup auto update now
  (add-hook 'prog-mode-hook
            (lambda ()
              (add-hook 'after-save-hook
                        'counsel-etags-virtual-update-tags 'append 'local)))
  )
