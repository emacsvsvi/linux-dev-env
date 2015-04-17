;;; Init --- My initilization code:
;;; Commentary:
;;; Trying to get rid of errors

;; load paths
;;; Code:
(setq load-path (cons (concat pkg-dir "site-lisp") load-path))
(setq load-path (cons (concat pkg-dir "emacs-colors-solarized") load-path))

;; Installation functionality
;; This uses ~/.emacs.d/elpa to load all of the installed packages.
;; Link this directory with ~/dev-env/emacs-packages/elpa so that we can make it
;; mobile between installations

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; Get rid of ANNOYING beeps...
(setq ring-bell-function 'ignore)

;; Change html indent to 4 spaces
(add-hook 'html-mode-hook
    (lambda ()
        ;; Default indentation is usually 2 spaces, changing to 4.
        (set (make-local-variable 'sgml-basic-offset) 4)))

(setq-default indent-tabs-mode nil)
(message "before")
(require 'flycheck-java)
(add-hook 'java-mode-hook
          (lambda () (setq flycheck-java-ecj-jar-path (concat pkg-dir "ecj.jar"))))
(message "after")

;; Turn on flycheck for syntax checking
(add-hook 'after-init-hook #'global-flycheck-mode)

;;loading ergo emacs
;; Changed M-O to M-Q to overcome arrow issue in us file.
(setenv "ERGOEMACS_KEYBOARD_LAYOUT" "us") ; US layout
;; load ErgoEmacs keybinding
(load-file (concat pkg-dir "ergoemacs-keybindings-5.3.7/ergoemacs-mode.el"))
;; turn on minor mode ergoemacs-mode
(ergoemacs-mode 1)
(message "next")
;;loading my keybindings
(load-file (concat pkg-dir "site-lisp/stan-keys.el"))

;; load mercurial package
;;(require 'mercurial)

;; Set color themeXS
(require 'color-theme-solarized)
(color-theme-solarized-dark)

;; java syntax At work we use tabs...
(setq-default tab-width 4)
(message "later")

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
;;; emacsinit-min.el ends here


