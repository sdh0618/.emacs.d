;; User details
(setq user-full-name "Deheng Song")
(setq user-mail-address "dhsong@vt.edu")

;; Package management
(load "package")
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(package-initialize)
;; (package-refresh-contents)

;; Define default packages
(defvar dhsong/packages '(
			  auctex
                          auto-complete
                          autopair
			  persistent-scratch
			  ;;elpy
			  ;;flycheck
			  ;;magit
                          markdown-mode
                          org
                          pdf-tools
			  ;;powerline
			  ;;smex
                          solarized-theme
			  writegood-mode
			  yasnippet
                          )
  "Default packages")

;; Install default packages
(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-refresh-contents)
	    (package-install package)))
      dhsong/packages)

;; Start-up options
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
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c C-k") 'compile)
(global-set-key (kbd "C-x g") 'magit-status)
;;;; Misc
(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)
(show-paren-mode t)

;; Org
;;;; Settings
(setq org-log-done t
      org-todo-keywords '((sequence "TODO" "INPROGRESS" "DONE"))
      org-todo-keyword-faces '(("INPROGRESS" . (:foreground "blue" :weight bold))))
(add-hook 'org-mode-hook
          (lambda ()
            (flyspell-mode)))
(add-hook 'org-mode-hook
          (lambda ()
            (writegood-mode)))

;; Utilities
;;;; Ido
(ido-mode t)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t)
;;;; Column number mode
(setq column-number-mode t)
;;;; Temporary file management
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))
;;;; autopair-mode
(require 'autopair)
;;;; auto-complete
(require 'auto-complete-config)
(ac-config-default)

;;;; Indentation and buffer cleanup
(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun cleanup-region (beg end)
  "Remove tmux artifacts from region."
  (interactive "r")
  (dolist (re '("\\\\│\·*\n" "\W*│\·*"))
    (replace-regexp re "" nil beg end)))

(global-set-key (kbd "C-x M-t") 'cleanup-region)
(global-set-key (kbd "C-c n") 'cleanup-buffer)

(setq-default show-trailing-whitespace t)
;;;;;

;; Set PATH Variable
(setenv "PATH" (concat (getenv "PATH") ":/home/dhsong/.bin/:/home/dhsong/.texlive/2019/bin/x86_64-linux:/home/dhsong/anaconda3/bin:/home/dhsong/anaconda3/condabin"))
(setq exec-path (append exec-path '("/home/dhsong/.bin/:/home/dhsong/.texlive/2019/bin/x86_64-linux:/home/dhsong/anaconda3/bin:/home/dhsong/anaconda3/condabin")))

;; Update PDF buffers after successful LaTeX runs
(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)

;; Enable recent file
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; Enable autosave and restore scratch
(persistent-scratch-setup-default)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-selection
   (quote
    (((output-dvi has-no-display-manager)
      "dvi2tty")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "PDF Tools")
     (output-html "xdg-open"))))
 '(package-selected-packages
   (quote
    (solarized-theme smex powerline pdf-tools markdown-mode magit flycheck elpy autopair auto-complete auctex)))
 '(preview-TeX-style-dir "/home/dhsong/.emacs.d/elpa/auctex-12.2.0/latex" t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
