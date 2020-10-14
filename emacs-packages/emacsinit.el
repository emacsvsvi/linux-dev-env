;;; Init --- My initilization code:
;;; Commentary:
;;; Trying to get rid of errors

;; Load the minimal file so don't repeat
;;; Code:
(load-file (concat pkg-dir "emacsinit-min.el"))

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; The following lines are for org mode.
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;; This shouldn't be here, but it will be in mercurial so we will use it for now.
(setq org-agenda-files (file-expand-wildcards "~/dev-env/org/*.org"))

;; save the desktop for next time
(desktop-save-mode 1)
(setq history-length 250)
(setq desktop-restore-eager 10)
(add-to-list 'desktop-globals-to-save 'file-name-history)

(defun desktop-auto-save ()
  "Added to auto-save-hook so the desktop is not lost."
  (message "Wrote desktop."))

(add-hook 'auto-save-hook 'desktop-auto-save t)

;; templating setup using yasnippet
(require 'yasnippet) ;; not yasnippet-bundle
(yas-global-mode 1)

;; Added this to try and get autocompletion to work for Java again.
(require `auto-complete)
(global-auto-complete-mode t)
(ac-config-default)

;; buffer naming instead of <2> uses directory names.
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)

(setq ibuffer-shrink-to-minimum-size t)
(setq ibuffer-always-show-last-buffer nil)
(setq ibuffer-sorting-mode 'recency)
(setq ibuffer-use-header-line t)
(global-set-key [(f12)] 'ibuffer)

;; Brief window movement using shift arrow keys
(windmove-default-keybindings)

;; ========== Place Backup Files in Specific Directory ==========
;; Enable backup files.
(setq make-backup-files t)
;; Enable versioning with default values (keep five last versions, I think!)
(setq version-control t)
;; So that I don't get annoying question about deleting older versions 
(setq delete-old-versions t)
;; Save all backup file in this directory.
(setq backup-directory-alist (quote (("." . "~/.emacs_backups/"))))

;;  cedet semantic loading commands
;;(load-file (concat pkg-dir "cedet-1.1/common/cedet.el"))
;;(semantic-load-enable-excessive-code-helpers)
;;(require 'semantic-ia)
;;(require 'semantic-java)

;; Windows specific stuff
(when (eq system-type 'windows-nt)
  ;; Maximize frame
  (message "We are in win-nt")
  (defun w32-maximize-frame ()
      "Maximize the current frame"
      (interactive)
      (w32-send-sys-command 61488)
	  (sleep-for 2)
	  (ecb-redraw-layout))
 
  (add-hook 'window-setup-hook 'w32-maximize-frame t)

  ;; fix cygwin path issues
  (setenv "PATH" (concat (concat apps-dir "cygwin/bin;") (getenv "PATH")))
  (setq exec-path (cons (concat apps-dir "cygwin/bin/") exec-path))
  (require 'cygwin-mount)
  (cygwin-mount-activate)

  ;; load cygwin bash shell
  (add-hook 'comint-output-filter-functions
            'shell-strip-ctrl-m nil t)
  (add-hook 'comint-output-filter-functions
            'comint-watch-for-password-prompt nil t)
  (setq explicit-shell-file-name "bash.exe")
  ;; For subprocesses invoked via the shell
  ;; (e.g., "shell -c command")
  (setq shell-file-name explicit-shell-file-name)

  ;; cygwin keybindings for previous command functionality
  (add-hook 'shell-mode-hook 'n-shell-mode-hook)
  (defun n-shell-mode-hook ()
    "12Jan2002 - sailor, shell mode customizations."
    (local-set-key '[up] 'comint-previous-input)
    (local-set-key '[down] 'comint-next-input)
    (local-set-key '[(shift tab)] 'comint-next-matching-input-from-input))

  '(ecb-source-path (quote ("T:\\ccstore\\icrs3" "t:\\ccstore\\views")))
  (message "Adding 1.6.0-7")
)

;; When not windows
;; Commented out because not sure what the use is, and work servers
;; don't have wmctrl installed.
;; (unless (eq system-type 'windows-nt)
;;   (message "Not win-nt")
;;   (defun switch-full-screen ()
;;     (interactive)
;;     (shell-command "wmctrl -r :ACTIVE: -btoggle,maximized_horz,maximized_vert"))

;;   (global-set-key [f11] 'switch-full-screen)
;;   (switch-full-screen)
;; )

;; pymacs
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(eval-after-load "pymacs" '(add-to-list 'pymacs-load-path (concat pkg-dir "pymacs-code")))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(nxml-child-indent 4)
 '(org-startup-indented t))

;; malabar-mode - or enable more if you wish
;; (setq load-path (cons (concat pkg-dir "malabar-1.4.1-SNAPSHOT/lisp") load-path))
;; (setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
;;                                   global-semanticdb-minor-mode
;;                                   global-semantic-idle-summary-mode
;;                                   global-semantic-mru-bookmark-mode))
;; (semantic-mode 1)
;; (require 'malabar-mode)
;; (setq malabar-groovy-lib-dir (concat pkg-dir "malabar-1.4.1-SNAPSHOT/lib"))
;; (add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))
;;; emacsinit.el ends here
