;; enable melpa package
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
;; refresh and install packages for initial configuration
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; always ensure packages
;; for built-in packages use ":ensure nil" to avoid errors
(require 'use-package-ensure)
(setq use-package-always-ensure t)
(package-initialize)                ;; Initialize & Install Package

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
;;;; persistent-scratch
(use-package persistent-scratch
  :config (persistent-scratch-setup-default))
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
  (pyvenv-activate "/home/dhsong/.local/venv/base")
  (setq elpy-rpc-virtualenv-path 'current))
;; (use-package virtualenvwrapper
;;   :init
;;   (venv-initialize-interactive-shells)
;;   (venv-initialize-eshell)
;;   (setq venv-location "~/")
;;   :config
;;   (venv-workon "venv"))
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
;;;; flyspell
(use-package flyspell
  :defer t
  :init
  (progn
    (add-hook 'prog-mode-hook 'flyspell-prog-mode)
    (add-hook 'text-mode-hook 'flyspell-mode)
    )
  :config
  ;; Sets flyspell correction to use two-finger mouse click
  ;; (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
  )
;; Org Mode
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(setq org-ellipsis "⤵")
;; (setq org-latex-pdf-process
;;       '("pdflatex -interaction nonstopmode -output-directory %o %f"
;;         "biber %b"
;;         "pdflatex -interaction nonstopmode -output-directory %o %f"
;;         "pdflatex -interaction nonstopmode -output-directory %o %f"))
(setq org-latex-pdf-process
      '("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -bibtex -f %f"))

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

(use-package ivy-bibtex
  :init
  (setq bibtex-completion-bibliography '("~/Dropbox/Bibtex/main.bib")
	bibtex-completion-library-path '("~/Dropbox/Bibtex/pdf/")
	bibtex-completion-notes-path "~/Dropbox/Bibtex/notes/"
	bibtex-completion-notes-template-multiple-files "* ${author-or-editor}, ${title}, ${journal}, (${year}) :${=type=}: \n\nSee [[cite:&${=key=}]]\n"

	bibtex-completion-additional-search-fields '(keywords)
	bibtex-completion-display-formats
	'((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
	  (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
	  (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	  (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	  (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))
	bibtex-completion-pdf-open-function
	(lambda (fpath)
	  (call-process "open" nil 0 nil fpath))))

(use-package org-ref
  ;; :ensure nil
  ;; :load-path (lambda () (expand-file-name "org-ref" scimax-dir))
  :init
  ;; (add-to-list 'load-path
  ;; 	       (expand-file-name "org-ref" scimax-dir))
  (require 'bibtex)
  (setq bibtex-autokey-year-length 4
	bibtex-autokey-name-year-separator "-"
	bibtex-autokey-year-title-separator "-"
	bibtex-autokey-titleword-separator "-"
	bibtex-autokey-titlewords 2
	bibtex-autokey-titlewords-stretch 1
	bibtex-autokey-titleword-length 5)
  (define-key bibtex-mode-map (kbd "H-b") 'org-ref-bibtex-hydra/body)
  (define-key org-mode-map (kbd "C-c )") 'org-ref-insert-link)
  (define-key org-mode-map (kbd "s-[") 'org-ref-insert-link-hydra/body)
  (require 'org-ref-ivy)
  (require 'org-ref-arxiv)
  (require 'org-ref-scopus)
  (require 'org-ref-wos)
  )


(use-package org-ref-ivy
  :ensure nil
  ;; :load-path (lambda () (expand-file-name "org-ref" scimax-dir))
  :init (setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
	      org-ref-insert-cite-function 'org-ref-cite-insert-ivy
	      org-ref-insert-label-function 'org-ref-insert-label-link
	      org-ref-insert-ref-function 'org-ref-insert-ref-link
	      org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body))))
;;;; Org-ref
;; (use-package org-ref
;;   :init
;;   ;; (setq org-ref-completion-library 'org-ref-ivy-cite)
;;   :config
;;   (setq reftex-default-bibliography '("~/Dropbox/Bibtex/main.bib"))
;;   (setq org-ref-bibliography-notes "~/Dropbox/Bibtex/notes.org"
;; 	org-ref-default-bibliography '("~/Dropbox/Bibtex/main.bib")
;; 	org-ref-pdf-directory "~/Dropbox/Bibtex/pdf/"))

;; (use-package bibtex-completion
;;   :config
;;   (setq bibtex-completion-bibliography "~/Documents/Bibtex/main.bib"
;; 	bibtex-completion-library-path "~/Documents/Bibtex/pdf/"
;; 	bibtex-completion-notes-path "~/Documents/Bibtex/notes.org"))

(use-package org-roam
  :init
;  (setq org-roam-v2-ack t)
;  (org-roam-setup)
  :custom
  (org-roam-directory (file-truename "~/Documents/Roam-Notes"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If using org-roam-protocol
  ;; (require 'org-roam-protocol)
  )

;; ;;;; Org-roam-bibtex
;; (use-package org-roam-bibtex
;;   :after org-roam
;;   :hook (org-roam-mode . org-roam-bibtex-mode)
;;   :config
;;   (setq orb-templates
;;         `(("w" "ref" plain (function org-roam-capture--get-point)
;;            ""
;;            :file-name "papers/${slug}"
;;            :head ,(concat
;;                    "#+title: ${=key=}: ${title}\n"
;;                    "#+roam_key: ${ref}\n\n"
;;                    "* ${title}\n"
;;                    "  :PROPERTIES:\n"
;;                    "  :Custom_ID: ${=key=}\n"
;;                    "  :URL: ${url}\n"
;;                    "  :AUTHOR: ${author-or-editor}\n"
;;                    "  :NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
;;                    "  :NOTER_PAGE: \n"
;;                    "  :end:\n")
;;            :unnarrowed t))))
;; (use-package org-roam-server
;;   :ensure t
;;   :defer t
;;   :config
;;   (setq org-roam-server-host "127.0.0.1"
;;         org-roam-server-port 8080
;;         org-roam-server-authenticate nil
;;         org-roam-server-export-inline-images t
;;         org-roam-server-serve-files nil
;;         org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
;;         org-roam-server-network-poll t
;;         org-roam-server-network-arrows nil
;;         org-roam-server-network-label-truncate t
;;         org-roam-server-network-label-truncate-length 60
;;         org-roam-server-network-label-wrap-length 20))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(delete-selection-mode nil)
 '(org-agenda-files '("/home/dhsong/Dropbox/Bibtex/notes/Karkevandi2021.org"))
 '(org-format-latex-options
   '(:foreground default :background default :scale 1.75 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
		 ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(org-preview-latex-image-directory "~/.ltximg")
 '(package-selected-packages
   '(persistent-scratch org-roam-server org yasnippet-snippets use-package treemacs smex projectile org-roam-bibtex neotree elpy doom-themes doom-modeline counsel cdlatex auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
