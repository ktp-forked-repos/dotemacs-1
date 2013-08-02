;;; elim --- instant messenger
;;; Commentary:
;;; Code:

(defun user/elim-init ()
  "Initialize elim."
  (setq-default
   lui-max-buffer-size 30000
   lui-flyspell-p t
   lui-flyspell-alist '(("." "american"))
   elim-directory (path-join *user-cache-directory* "elim"))

  (define-key user/utilities-map (kbd "i") 'garak))

(if (pkg-config-has-p "libxml-2.0")
    (require-package '(:name elim :after (user/elim-init)))
  (message "libxml-2.0 not found, skipping ELIM."))


(provide 'utilities/elim)
;;; elim.el ends here
