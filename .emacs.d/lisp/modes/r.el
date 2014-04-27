;;; r.el --- R mode support
;;; Commentary:
;;; Code:

(defun user/R-mode-hook ()
  "R programming mode hook."
  (unless (derived-mode-p 'prog-mode)
    (run-hooks 'prog-mode-hook)))


(defun user/ess-mode-hook ()
  "ESS mode hook."
  (user/ess-mode-common-hook))


(defun user/ess-mode-common-hook ()
  "ESS common mode hook."
  (when (el-get-package-is-installed 'ac-R)
    (ess-ac-init))

  ;;; (Bindings) ;;;
  (user/bind-key-local :code :eval-buffer 'ess-eval-buffer)
  (user/bind-key-local :code :eval-function 'ess-eval-function)
  (user/bind-key-local :code :eval-selection 'user/ess-eval-region)
  (user/bind-key-local :code :eval-expression 'ess-eval-line))


(defun user/inferior-ess-mode-hook ()
  "Inferior ESS mode hook."
  (user/ess-mode-common-hook)

  (setq
   ;; Make R prompt read only.
   comint-prompt-read-only t))


(defun user/ess-R-post-run-hook ()
  "ESS R post run hook."
  ;; Make R expand to the full width of the buffer.
  (ess-execute-screen-options))


(defun user/ess-start-R ()
  "If R is not running launch it in an inferior frame."
  (interactive)
  (if (not (member "*R*" (mapcar (function buffer-name) (buffer-list))))
      (progn
        (delete-other-windows)
        (let ((window1 (selected-window))
              (window1-name (buffer-name))
              (window2 (split-window (selected-window))))
          (R)
          (set-window-buffer window2 "*R*")
          (set-window-buffer window1 window1-name)))))


(defun user/ess-eval-region ()
  "Evaluate active region."
  (interactive)
  (user/ess-start-R)
  (if (and transient-mark-mode mark-active)
      (call-interactively 'ess-eval-line-and-step)))


(defun user/ac-R-init ()
  "Initialize R auto completion."
  (autoload 'ess-ac-init "ac-R"))


(defun user/ess-init ()
  "Initialize Emacs Speaks Statistics."
  (setq-default
   ;; Use auto completion in ESS modes.
   ess-use-auto-complete t
   ;; The default ESS dialect is R.
   ess-dialect "R"
   ;; Use ElDoc in all ESS modes.
   ess-use-eldoc t
   ess-eldoc-show-on-symbol t
   ;; Optimize by only printing results, not code.
   ess-eval-visibly-p nil
   ;; Automatically scroll when output reaches bottom of buffer.
   ess-comint-scroll-to-bottom-on-output t
   ;; Start R in the current directory.
   ess-ask-for-ess-directory nil
   ess-local-process-name "R"
   ;; Enable ElDoc support.
   ess-use-eldoc t)

  ;; Register mode hooks.
  (add-hook 'ess-mode-hook 'user/ess-mode-hook)
  (add-hook 'inferiormode-ess-mode-hook 'user/inferior-ess-mode-hook)
  (add-hook 'R-mode-hook 'user/R-mode-hook)
  (add-hook 'ess-R-post-run-hook 'user/ess-R-post-run-hook)

  ;; Register auto modes.
  (add-auto-mode 'R-mode "\\.R$")

  ;;; (Bindings) ;;;
  (user/bind-key-global :apps :statistics 'R))

(with-executable 'R
  (require-package '(:name ess :after (user/ess-init)))
  (require-package '(:name ess-smart-underscore))
  (require-package '(:name ac-R :after (user/ac-R-init))))


(provide 'modes/r)
;;; r.el ends here