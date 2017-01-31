;;; info.el --- Info mode.
;;; Commentary:
;;; Code:

(defun user--info-mode-hook ()
  "Info mode hook."
  (when (feature-p 'info+)
    (require 'info+))

  (user/bind-key-local :nav :go-forward 'Info-history-forward)
  (user/bind-key-local :nav :go-back 'Info-history-back))


(defun user--info+-config ()
  "Initialize info+."
  (setq-default
   ;; Enable breadcrumbs in header line.
   Info-breadcrumbs-in-header-flag t
   Info-breadcrumbs-in-mode-line-mode nil))


(defun user--info-mode-config ()
  "Initialize info mode."
  ;;; (Packages) ;;;
  (use-package info+
    :ensure t
    :config (user--info+-config))

  (use-package helm-info
    :ensure helm
    :bind (("C-c h h e" . helm-info-emacs)
           ("C-c h h i" . helm-info-at-point)))

  ;;; (Hooks) ;;;
  (add-hook 'Info-mode-hook 'user--info-mode-hook))

(user--info-mode-config)


(provide 'modes/info)
;;; info.el ends here
