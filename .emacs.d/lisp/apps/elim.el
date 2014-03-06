;;; elim.el --- instant messenger
;;; Commentary:
;;; Code:

(defun user/elim-init ()
  "Initialize elim."
  (setq-default
   lui-max-buffer-size 30000
   lui-flyspell-p t
   lui-flyspell-alist '(("." "american"))
   elim-directory (path-join *user-cache-directory* "elim"))

  ;;; (Bindings) ;;;
  (user/bind-key-global :apps :instant-messenger 'garak))

(when *has-libpurple*
  (require-package '(:name elim :after (user/elim-init))))


(provide 'apps/elim)
;;; elim.el ends here