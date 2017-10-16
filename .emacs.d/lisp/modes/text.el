;;; text.el --- text mode support -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defun user--text-mode-hook ()
  "Text mode hook."
  (user--fundamental-mode-hook)

  (user/smartparens-enable)

  (setq
   ;; Colons are followed by two spaces.
   colon-double-space t
   ;; Sentences end after two spaces.
   sentence-end-double-space t
   ;; When using fill-paragraph or auto-fill-mode break lines at 79 characters
   ;; by default.
   fill-column 79
   ;; Indent using spaces.
   indent-tabs-mode nil)

  (when (user-flyspell-p)
    ;; Protect against missing dictionary.
    (try-eval
        ;; Run spell-checker in programming mode.
        (flyspell-prog-mode)))

  (with-feature 'flycheck-vale
    (flycheck-vale-setup))

  (with-feature 'pandoc-mode
    (pandoc-mode t))

  ;; Nicely wrap long lines.
  (visual-line-mode t)

  ;;; (Bindings) ;;;
  (user/bind-key-local :code :fill-paragraph 'fill-paragraph))

(use-package text-mode
  :ensure nil
  :defer
  :init
  (add-hook 'text-mode-hook 'user--text-mode-hook)
  :config
  (with-eval-after-load 'smartparens
    (sp-with-modes '(text-mode)
      (sp-local-pair "`" "'" :actions '(insert wrap))))

  (use-package flycheck-vale
    :if (executable-find "vale")))


(provide 'modes/text)
;;; text.el ends here
