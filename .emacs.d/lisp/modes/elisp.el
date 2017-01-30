;;; elisp.el --- Initializes Emacs Lisp modes
;;; Commentary:
;;; Code:

(defun user/emacs-lisp-mode-hook ()
  "Emacs Lisp mode hook."
  (user/lisp-mode-common-hook)

  (with-feature 'auto-compile
    (auto-compile-on-save-mode t)
    (auto-compile-on-load-mode t))

  (with-feature 'elisp-slime-nav
    (elisp-slime-nav-mode t)
    (after-load 'diminish
      (diminish 'elisp-slime-nav-mode)))

  (cond
   ((user/auto-complete-p)
    (ac-emacs-lisp-mode-setup))
   ((user/company-mode-p)
    (with-feature 'company-elisp
      (add-company-sources 'company-elisp))))

  ;;; (Bindings) ;;;
  (with-feature 'popwin
    (user/bind-key-local :util :popwin-messages 'popwin:messages))

  (with-feature 'macrostep
    (user/bind-key-local :code :macro-expand 'macrostep-expand))

  (user/bind-key-local :doc :reference 'elisp-index-search)
  (user/bind-key-local :doc :describe 'user/elisp-describe-thing-in-popup)
  (user/bind-key-local :doc :describe-function 'describe-function)
  (user/bind-key-local :doc :describe-variable 'describe-variable)

  (user/bind-key-local :debug :start 'debug)
  (user/bind-key-local :debug :break 'edebug-defun)
  (user/bind-key-local :debug :trace 'trace-function-background)
  (user/bind-key-local :debug :continue 'debugger-continue)
  (user/bind-key-local :debug :step 'debugger-step-through))


(defun user/ielm-mode-hook ()
  "Interactive Emacs Lisp mode hook."
  (user/emacs-lisp-mode-hook))


(defun user/minibuffer-setup-hook ()
  "Emacs minibuffer hook."
  (when (eq this-command 'eval-expression)
    (when (feature-p 'rainbow-delimiters)
      (rainbow-delimiters-mode))
    (when (feature-p 'paredit)
      (enable-paredit-mode))))


(defun user/elisp-describe-thing-in-popup ()
  "Describe elisp thing at point in a popup."
  (interactive)
  (with-feature 'popup
    (let* ((thing (symbol-at-point))
           (help-xref-following t)
           (description (with-temp-buffer
                          (help-mode)
                          (help-xref-interned thing)
                          (buffer-string))))
      (popup-tip description
                 :point (point)
                 :around t
                 :height 30
                 :scroll-bar t
                 :margin t))))


(defun user/eldoc-eval-init ()
  "Initialize eldoc eval."
  (eldoc-in-minibuffer-mode t))


(defun user/ielm-init ()
  "Initialize interactive elisp mode."
  ;; Use auto-completion even in inferior elisp mode.
  (add-ac-modes 'inferior-emacs-lisp-mode)

  (add-hook 'ielm-mode-hook 'user/ielm-mode-hook))


(defun user/elisp-mode-init ()
  "Initialize Emacs Lisp modes."
  (after-load 'ielm
    (user/ielm-init))

  ;;; (Hooks) ;;;
  (add-hook 'emacs-lisp-mode-hook 'user/emacs-lisp-mode-hook)
  (add-hook 'minibuffer-setup-hook 'user/minibuffer-setup-hook)

  (add-auto-mode 'emacs-lisp-mode "Carton$")

  ;;; (Packages) ;;;
  (require-package '(:name macrostep))
  (require-package '(:name elisp-slime-nav))
  (require-package '(:name auto-compile))
  (require-package '(:name eldoc-eval :after (user/eldoc-eval-init))))

(after-load 'modes/lisp
  (user/elisp-mode-init))


(provide 'modes/elisp)
;;; elisp.el ends here
