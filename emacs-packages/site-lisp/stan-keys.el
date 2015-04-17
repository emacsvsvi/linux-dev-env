
;;  Had to update the ergonomic key board specification to remove
;;  the C-l from the list of unbound keys.
(global-set-key (kbd "C-l") 'goto-line)
(global-set-key (kbd "M-m") 'flycheck-next-error)
(global-set-key (kbd "M-M") 'flycheck-previous-error)

;; This is so that the arrow keys will work.
(global-unset-key (kbd "M-O"))

;;  Command mode (ie shell mode) changes - actually reverting to the original
(add-hook 'comint-mode-hook
 (lambda ()
   (define-key comint-mode-map (kbd "M-p") 'comint-previous-input)
   (define-key comint-mode-map (kbd "M-n") 'comint-next-input)
   (define-key comint-mode-map (kbd "M-r") 'comint-previous-matching-input)
))
