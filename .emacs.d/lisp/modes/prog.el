;;; prog.el --- setup shared defaults for programming modes
;;; Commentary:
;;; Code:

(defun user/prog-mode-hook ()
  "Programming mode hook."
  (user/fundamental-mode-hook)

  ;; Protect against missing dictionary.
  (try-eval
      ;; Run spell-checker in programming mode.
      (flyspell-prog-mode))

  ;; Try to enable completion system.
  (cond
   ((user/auto-complete-p) (auto-complete-mode t))
   ((user/company-mode-p) (company-mode t)))

  ;;; (Bindings) ;;;
  (user/bind-key-local :code :comment (if (feature-p 'comment-dwim-2)
                                          'comment-dwim-2 'comment-dwim)))


(defun user/prog-mode-init ()
  "Initialize generic programming mode."
  (add-hook 'prog-mode-hook 'user/prog-mode-hook)

  ;;; (Packages) ;;;
  (use-package comment-dwim-2
    :ensure t))

(user/prog-mode-init)


(provide 'modes/prog)
;;; prog.el ends here
