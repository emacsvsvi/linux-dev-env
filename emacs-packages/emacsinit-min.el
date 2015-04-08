;; python mode setup
(setq load-path (cons (concat pkg-dir "python-mode-5.1.0") load-path))
(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(add-hook 'python-mode-hook
    (lambda ()
	    (message "in python mode hook lambda")
        (setq-default tab-width 4)
        (indent-tabs-mode . nil)))

;; Get rid of ANNOYING beeps...
(setq ring-bell-function 'ignore)

;; Change html indent to 4 spaces
(add-hook 'html-mode-hook
    (lambda ()
        ;; Default indentation is usually 2 spaces, changing to 4.
        (set (make-local-variable 'sgml-basic-offset) 4)))

(setq-default indent-tabs-mode nil)

;; load path
(setq load-path (cons (concat pkg-dir "color-theme-6.6.0") load-path))
(setq load-path (cons (concat pkg-dir "site-lisp") load-path))
(setq load-path (cons (concat pkg-dir "emacs-colors-solarized") load-path))

;;loading ergo emacs
;; Changed M-O to M-Q to overcome arrow issue in us file.
(setenv "ERGOEMACS_KEYBOARD_LAYOUT" "us") ; US layout
;; load ErgoEmacs keybinding
(load-file (concat pkg-dir "ergoemacs-keybindings-5.3.7/ergoemacs-mode.el"))
;; turn on minor mode ergoemacs-mode
(ergoemacs-mode 1)

;;loading my keybindings
(load-file (concat pkg-dir "site-lisp/stan-keys.el"))

;; load mercurial package
(require 'mercurial)

;; Set color themeXS
(require 'color-theme)
(color-theme-initialize)
(message "color initialized")
(require 'color-theme-solarized)
;; Not sure what this was supposed to do. Just set to solarized dark for now
;;(if (boundp 'use-theme)
;;    (message "use theme true")
;;    (message "use theme false"))
;;     (funcall use-theme))
     (color-theme-solarized-dark)

;; java syntax At work we use tabs...
(setq-default tab-width 4)

;; xml package
(load-file (expand-file-name (concat pkg-dir "/nxml-mode-20041004/rng-auto.el")))
(setq auto-mode-alist
      (cons '("\\.\\(xml\\|xsl\\|rng\\|xhtml\\)\\'" . nxml-mode)
        auto-mode-alist))
(defun my-xnml-hook()
	    (message "in my nxml mode")
        (indent-tabs-mode . t))
(setq nxml-child-indent 4)
(add-hook 'nxml-mode-hook 'my-nxml-hook)

(put 'scroll-left 'disabled nil)

;; Some stuff from Steve Yegge's suggestions
(require 'ido)
(ido-mode 'buffer)
(setq ido-enable-flex-matching t)

;; auto-complete configuration
(add-to-list 'load-path (concat pkg-dir "/auto-complete"))
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories (concat pkg-dir "/auto-complete/ac-dict"))
(ac-config-default)

;; ========== Line by line scrolling ==========

;; This makes the buffer scroll by only a single line when the up or
;; down cursor keys push the cursor (tool-bar-mode) outside the
;; buffer. The standard emacs behaviour is to reposition the cursor in
;; the center of the screen, but this can make the scrolling confusing

(setq scroll-step 1)

;; Show column-number in the mode line
(column-number-mode 1)

;; Paging corrected to work as I expect.  Currently, not interested in changing the row up and down functionality.
;; Overrode the keys in the ergonomic page.
(require 'pager)
(define-key ergoemacs-keymap ergoemacs-scroll-down-key 'pager-page-up)
(define-key ergoemacs-keymap ergoemacs-scroll-up-key 'pager-page-down)
(global-set-key [next]    'pager-page-down)
(global-set-key [prior] 'pager-page-up)
;;;     (global-set-key '[M-up]    'pager-row-up)
;;;     (global-set-key '[M-kp-8]  'pager-row-up)
;;;     (global-set-key '[M-down]  'pager-row-down)
;;;     (global-set-key '[M-kp-2]  'pager-row-down)

(defun apache-jakarta-mode ()
  "The Java mode specialization for Apache Jakarta projects."
  (message "jakarta-mode")
  (if (not (assoc "apache-jakarta" c-style-alist))
      ;; Define the Apache Jakarta cc-mode style.
      (c-add-style "apache-jakarta" '("java" (indent-tabs-mode . t)))) ;; Use tabs for indentation
;;      (c-add-style "apache-jakarta" '("java" (indent-tabs-mode . nil)))) ;; Use spaces for indentation

  (c-set-style "apache-jakarta")
  (c-set-offset 'substatement-open 0 nil)
  (setq mode-name "Apache Jakarta"))

;; Activate Jakarta mode.
(add-hook 'java-mode-hook 'apache-jakarta-mode)


