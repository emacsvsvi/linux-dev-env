;; Load the minimal file so don't repeat
(load-file (concat pkg-dir "emacsinit-min.el"))

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
(add-to-list 'load-path (concat pkg-dir "yasnippet-0.6.1c"))
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory (concat pkg-dir "yasnippet-0.6.1c/snippets"))

;; csharp mode
(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
  (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))

;; buffer naming instead of <2> uses directory names.
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)

(setq ibuffer-shrink-to-minimum-size t)
(setq ibuffer-always-show-last-buffer nil)
(setq ibuffer-sorting-mode 'recency)
(setq ibuffer-use-header-line t)
(global-set-key [(f12)] 'ibuffer)

;; Ability to edit pmwiki pages from within emacs
(add-to-list 'load-path (concat pkg-dir "pmwiki-mode"))
(require 'pmwiki-mode)
(setq pmwiki-main-wiki-base-uri "https://tuintlvs01/wiki/pmwiki.php")
(setq pmwiki-main-homepage-uri (concat pmwiki-main-wiki-base-uri "?n=Main.HomePage"))

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
(unless (eq system-type 'windows-nt)
  (message "Not win-nt")
  (defun switch-full-screen ()
    (interactive)
    (shell-command "wmctrl -r :ACTIVE: -btoggle,maximized_horz,maximized_vert"))

  (global-set-key [f11] 'switch-full-screen)
  (switch-full-screen)
)

;; pymacs
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(eval-after-load "pymacs" '(add-to-list 'pymacs-load-path (concat pkg-dir "pymacs-modules")))

;; pymdev
(pymacs-load "pymdev" "pymdev-")
(message "after pymdev")

(define-key global-map [(control z)] nil)
(global-set-key [(control z) (control z)] 'pymdev-eval-region-to-minibuffer)
(global-set-key [(control z) (control r)] 'pymdev-eval-region-in-place)
(global-set-key [(control z) (control i)] 'pymdev-eval-region-insert)
(global-set-key [(control z) (control x)] 'pymdev-exec-and-doctest-region)
(global-set-key [(control z) (control h)] 'pymdev-help-on-region)
(global-set-key [(control z) (control d)] 'pymdev-doctest-region)

(pymacs-load "load-pom-classpath")

;;  This is to run ant incrementally to see problems before building...
(when use-flymake
   (message "using flymake")
   (require 'flymake)
 
   (defun flymake-java-ecj-init ()
	 (let* ((temp-file   (flymake-init-create-temp-buffer-copy
						  'java-ecj-create-temp-file))
			(local-file  (file-relative-name
						  temp-file
						  (file-name-directory buffer-file-name))))
	   ;; Change your ecj.jar location here
	   (list "java" (list "-jar" (concat pkg-dir "ecj.jar") "-Xemacs" "-d" "/tmp" 
						  "-source" "1.5" "-target" "1.5" "-proceedOnError"
						  "-sourcepath" (load-pom-classpath-getSourcepath buffer-file-name) "-classpath" 
						  (load-pom-classpath-getClasspath buffer-file-name) local-file))))
 
   (defun flymake-java-ecj-cleanup ()
	 "Cleanup after `flymake-java-ecj-init' -- delete temp file and dirs."
	 (flymake-safe-delete-file flymake-temp-source-file-name)
	 (when flymake-temp-source-file-name
	   (flymake-safe-delete-directory (file-name-directory flymake-temp-source-file-name))))
 
   (defun java-ecj-create-temp-file (file-name prefix)
	 "Create the file FILE-NAME in a unique directory in the temp directory."
	 (file-truename (expand-file-name (file-name-nondirectory file-name)
									  (expand-file-name  (int-to-string (random)) (flymake-get-temp-dir)))))
 
   (push '(".+\\.java$" flymake-java-ecj-init flymake-java-ecj-cleanup) flymake-allowed-file-name-masks)
 
   (push '("\\(.*?\\):\\([0-9]+\\): error: \\(.*?\\)\n" 1 2 nil 2 3 (6 compilation-error-face)) compilation-error-regexp-alist)
 
   (push '("\\(.*?\\):\\([0-9]+\\): warning: \\(.*?\\)\n" 1 2 nil 1 3 (6 compilation-warning-face)) compilation-error-regexp-alist)

   (defun credmp/flymake-display-err-minibuf () 
	 "Displays the error/warning for the current line in the minibuffer"
	 (interactive)
	 (let* ((line-no             (flymake-current-line-no))
			(line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
			(count               (length line-err-info-list)))
	   (while (> count 0)
		 (when line-err-info-list
		   (let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
				  (full-file  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
				  (text (flymake-ler-text (nth (1- count) line-err-info-list)))
				  (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
			 (message "[%s] %s" line text)))
		 (setq count (1- count)))))

   (defun display-next-err ()
	 "Go to the next error and display message"
	 (interactive)
	 (flymake-goto-next-error)
	 (credmp/flymake-display-err-minibuf))

    ;; (custom-set-faces
    ;;   ;; custom-set-faces was added by Custom.
    ;;   ;; If you edit it by hand, you could mess it up, so be careful.
    ;;   ;; Your init file should contain only one such instance.
    ;;   ;; If there is more than one, they won't work right.
    ;;     '(flymake-errline ((((class color)) (:background "firebrick" :foreground "beige"))))
    ;;     '(flymake-warnline ((((class color)) (:background "blue" :foreground "beige")))))

    (add-hook 'java-mode-hook 'flymake-mode)
)
;;  END fly-make

(add-hook 'java-mode-hook 'hs-minor-mode)

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
