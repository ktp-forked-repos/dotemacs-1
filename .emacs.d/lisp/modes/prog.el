;;; prog.el --- setup shared defaults for programming modes -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defun user--prog-mode-hook ()
  "Programming mode hook."
  (user--fundamental-mode-hook)

  (when (user-flyspell-p)
    ;; Protect against missing dictionary.
    (try-eval
        ;; Run spell-checker in programming mode.
        (flyspell-prog-mode)))

  ;; Try to enable completion system.
  (cond
   ((user/auto-complete-p) (auto-complete-mode t))
   ((user/company-mode-p) (company-mode t)))

  ;;; (Bindings) ;;;
  (user/bind-key-local :code :comment (if (feature-p 'comment-dwim-2)
                                          'comment-dwim-2 'comment-dwim)))


(use-package prog-mode
  :ensure nil
  :init
  (add-hook 'prog-mode-hook 'user--prog-mode-hook)
  :config
  ;;; (Packages) ;;;
  (use-package comment-dwim-2))


(provide 'modes/prog)
;;; prog.el ends here
