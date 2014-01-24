;;; navigation.el --- Set up Emacs buffer navigation
;;; Commentary:
;;; Code:

(defun user/navigation-init ()
  "Set up Emacs buffer navigation."
  (require-package '(:name ace-jump-mode :after (user/ace-jump-mode-init)))
  (require-package '(:name smart-forward :after (user/smart-forward-init)))

  ;; Enable mouse in iTerm2
  (when (eq system-type 'darwin)
    (require 'mouse)
    (xterm-mouse-mode t)
    (defun track-mouse (e)))

  ;;; (Bindings) ;;;
  ;; Binds goto-line to navigation command g which is easier to access than M-g g
  (define-key user/navigation-map (kbd "g") 'goto-line))


(defun user/ace-jump-mode-init ()
  "Initialize ace jump mode."
  ;;; (Bindings) ;;;
  (define-key user/navigation-map (kbd "a") 'ace-jump-mode))


(defun user/smart-forward-init ()
  "Initialize smart-forward."
  (define-key user/navigation-map (kbd "s f") 'smart-forward)
  (define-key user/navigation-map (kbd "s b") 'smart-backward)
  (define-key user/navigation-map (kbd "s p") 'smart-up)
  (define-key user/navigation-map (kbd "s n") 'smart-down))


(user/navigation-init)


(provide 'ux/navigation)
;;; navigation.el ends here
