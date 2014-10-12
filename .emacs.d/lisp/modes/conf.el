;;; conf.el --- Initializes configuration mode
;;; Commentary:
;;; Code:

(defun user/conf-mode-hook ()
  "Configuration mode hook.")


(defun user/nginx-mode-init ()
  "Initialize nginx mode."
  (add-auto-mode 'nginx-mode "etc/nginx/.*$"))


(defun user/conf-mode-init ()
  "Initialize assembly mode."
  (add-hook 'conf-mode-hook 'user/conf-mode-hook)

  ;;; (Packages) ;;;
  (with-executable 'nginx
    (require-package '(:name nginx-mode :after (user/nginx-mode-init)))))

(user/conf-mode-init)


(provide 'modes/conf)
;;; conf.el ends here