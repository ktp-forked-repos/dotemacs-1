;;; syslog --- a mode for syslogs
;;; Commentary:
;;; Code:

(defun user/syslog-mode-hook ()
  "Hook for syslog-mode."
  ;; There is no need to spell check log files.
  (flyspell-mode-off)

  ;;; (Bindings) ;;;
  (local-set-key (kbd "f") 'syslog-filter-lines)
  (local-set-key (kbd "F") 'hide-lines-show-all))


(defun user/syslog-mode-init ()
  "Initialize syslog-mode."
  ;; Register auto mode for log files.
  (add-auto-mode 'syslog-mode "/var/log.*$" "\\.log$")

  (add-hook 'syslog-mode-hook 'user/syslog-mode-hook))

(use-package syslog-mode
  :ensure t
  :config (user/syslog-mode-init))


(provide 'modes/syslog)
;;; syslog.el ends here
