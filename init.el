;; enable melpa package
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-refresh-contents)
(package-initialize)
;; require use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Start-up options
;;;; personal information
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
;;;; Key bindings
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-<tab>") 'treemacs)
;; (global-set-key (kbd "C-c C-k") 'compile)
;; (global-set-key (kbd "C-x g") 'magit-status)
;;;; Misc
(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)
(show-paren-mode t)
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

;; Icons
(use-package all-the-icons)

;; Installing Ivy And Basic Setup
(use-package counsel
  :after ivy
  :config (counsel-mode))
(use-package ivy
  :defer 0.1
  :diminish
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
(use-package ivy-bibtex)

;; better M-x
(setq ivy-initial-inputs-alist nil)
(use-package smex)
(smex-initialize)

;; projectile
(use-package projectile
  :config
  (projectile-global-mode 1))

;; vterm
(use-package vterm)
(setq shell-file-name "/bin/bash"
      vterm-max-scrollback 5000)

;; themes
(use-package doom-themes)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled
(load-theme 'doom-one t)
(use-package doom-modeline)
(doom-modeline-mode 1)

;; side-windows
(use-package neotree)
(use-package treemacs)

;; LANGUAGE SUPPORT
(use-package elpy
  :init
  (elpy-enable))
;; (add-hook 'elpy-mode-hook (lambda () (local-unset-key (kbd "C-c C-c")))
(use-package tex
  :ensure auctex)
(use-package cdlatex)
(add-hook 'org-mode-hook 'turn-on-org-cdlatex)

;; company-mode
(use-package company)
(add-hook 'after-init-hook 'global-company-mode)

;; Yasnippets
(use-package yasnippet
  :config
  (yas-global-mode 1))
(use-package yasnippet-snippets)

;; Org Mode
(use-package org-ref)
;;;; org-ref
(setq reftex-default-bibliography '("~/Dropbox/Bibtex/main.bib"))
;;;; see org-ref for use of these variables
(setq org-ref-bibliography-notes "~/Dropbox/Bibtex/notes.org"
      org-ref-default-bibliography '("~/Dropbox/Bibtex/main.bib")
      org-ref-pdf-directory "~/Dropbox/Bibtex/pdf/")
;;;; Source block languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)
   (latex . t)
   (python . t)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files nil)
 '(package-selected-packages
   '(org-ref ivy-bibtex auctex elpy neotree doom-themes vterm Projectile smex all-the-icons use-package))
 '(projectile-mode t nil (projectile)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
