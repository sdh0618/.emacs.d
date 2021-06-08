;; enable melpa package
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
	     '("org" . "https://orgmode.org/elpa/") t)
(unless package-archive-contents    ;; Refresh the packages descriptions
  (package-refresh-contents))
(setq package-load-list '(all))     ;; List of packages to load
(unless (package-installed-p 'org)  ;; Make sure the Org package is
  (package-install 'org))           ;; installed, install it if not
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-always-ensure t)
(package-initialize)                ;; Initialize & Install Package
;; require use-package
;;(require 'use-package-ensure)

;; Start-up options
;;;; Personal information
(setq user-full-name "Deheng Song"
      user-mail-address "dhsong@vt.edu")
;;;; Splash Screen
(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)
;;;; Scroll bar, Tool bar, Menu bar
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
;;;; Marking text
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)
;;;; Display settings
(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))
;;;; Display Line Numbers and Truncated Lines
(global-display-line-numbers-mode 1)
(global-visual-line-mode t)
;;;; Scrolling
(setq scroll-conservatively 101) ;; value greater than 100 gets rid of half page jumping
(setq mouse-wheel-scroll-amount '(3 ((shift) . 3))) ;; how many lines at a time
(setq mouse-wheel-progressive-speed t) ;; accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
;;;; Indentation
(setq tab-width 2
      indent-tabs-mode nil)
;;;; Backup files
(setq make-backup-files nil)
;;;; Yes and No
(defalias 'yes-or-no-p 'y-or-n-p)
;;;; Misc
(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)
(show-paren-mode t)

;; Global key bindings
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c p") 'treemacs)
;;;; (global-set-key (kbd "C-c C-k") 'compile)
;;;; (global-set-key (kbd "C-x g") 'magit-status)

;; PATH
;;;; Set ‘exec-path’ to match shell PATH automatically
(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.

This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$" "" (shell-command-to-string
					  "$SHELL --login -c 'echo $PATH'"
						    ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))
(set-exec-path-from-shell-PATH)

;; Packages
;;;; All-the-icons
(use-package all-the-icons)
;;;; Ivy And Basic Setup
(use-package counsel
  :after ivy
  :config (counsel-mode))
(use-package ivy
  :defer 0.1
  :bind
  (("C-c C-r" . ivy-resume)
   ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-use-virtual-buffers t)
  ;; (setq enable-recursive-minibuffers t)
  :config
  (ivy-mode))
(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))
;;;; Better M-x
(setq ivy-initial-inputs-alist nil)
(use-package smex
  :config
  (smex-initialize))
;;;; Projectile
(use-package projectile
  :delight
  '(:eval (concat " " (projectile-project-name)))
  :custom
  (projectile-global-mode 1))
;;;; Themes
(use-package doom-themes
  :custom
  (setq doom-themes-enable-bold t) ; if nil, bold is universally disabled
  (setq doom-themes-enable-italic t) ; if nil, italics is universally disabled
  :init
  (load-theme 'doom-one t))
(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-minor-modes t))
;;;; Side-windows
(use-package neotree)
(use-package treemacs)
;;;; Languages
(use-package elpy
  :init
  (elpy-enable)
  :config
  (pyvenv-activate "~/venv"))
(use-package virtualenvwrapper
  :init
  (venv-initialize-interactive-shells)
  (venv-initialize-eshell)
  (setq venv-location "~/")
  :config
  (venv-workon "venv"))
(use-package tex
  :ensure auctex)
(use-package cdlatex
  :hook
  (org-mode . turn-on-org-cdlatex))
;;;; Company-mode
(use-package company)
(add-hook 'after-init-hook 'global-company-mode)
;;;; Yasnippets
(use-package yasnippet
  :custom
  (yas-global-mode 1))
(use-package yasnippet-snippets)

;; Org Mode
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(setq org-ellipsis "⤵")
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
;;;; Org-ref
(use-package org-ref
  :init
  ;; (setq org-ref-completion-library 'org-ref-ivy-cite)
  :config
  (setq reftex-default-bibliography '("~/Dropbox/Bibtex/main.bib"))
  (setq org-ref-bibliography-notes "~/Dropbox/Bibtex/notes.org"
	org-ref-default-bibliography '("~/Dropbox/Bibtex/main.bib")
	org-ref-pdf-directory "~/Dropbox/Bibtex/pdf/"))
(use-package bibtex-completion
  :config
  (setq bibtex-completion-bibliography "~/Dropbox/Bibtex/main.bib"
	bibtex-completion-library-path "~/Dropbox/Bibtex/pdf/"
	bibtex-completion-notes-path "~/Dropbox/Bibtex/notes.org"))
;;;; Org-roam
(use-package org-roam
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "~/Documents/Roam-Notes")
  :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n g" . org-roam-graph))
	      :map org-mode-map
              (("C-c n i" . org-roam-insert))
              (("C-c n I" . org-roam-insert-immediate))))
;;;; Org-roam-bibtex
(use-package org-roam-bibtex
  :after org-roam
  :hook (org-roam-mode . org-roam-bibtex-mode))
;;;; Org-babel
(setq org-src-fontify-natively t
      org-edit-src-content-indentation 0
      org-src-tab-acts-natively t
      org-src-preserve-indentation t
      org-confirm-babel-evaluate nil)
(org-babel-do-load-languages 'org-babel-load-languages
			     '((emacs-lisp . t)
			       (shell . t)
			       (latex . t)
			       (python . t)))
;;;; Org-roam-server
(use-package org-roam-server
  :after org-roam
  :hook (org-roam-mode . org-roam-server-mode)
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8080
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("~/Documents/Roam-Notes/Tibaldo2015.org" "/home/dhsong/Documents/Notes/GlobularCluster.org"))
 '(package-selected-packages
   '(org-roam-server org yasnippet-snippets use-package treemacs smex projectile org-roam-bibtex neotree elpy doom-themes doom-modeline counsel cdlatex auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
