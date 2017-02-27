;;; verilog.el --- Verilog mode support -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defun user--verilog-mode-hook ()
  "Verilog mode hook."
  (user/gnu-global-enable))


(use-package verilog-mode
  :defer
  :quelpa (verilog-mode
           :fetcher url
           :url "http://www.veripool.org/ftp/verilog-mode.el")
  :init
  (add-hook 'verilog-mode-hook 'user--verilog-mode-hook)
  (add-auto-mode 'verilog-mode "\\.[ds]?vh?$")
  :config
  (when (feature-p 'polymode)
    (add-auto-mode 'poly-verilog+perl-mode "\\.sv$" "\\.svh$"))

  ;;; (Packages) ;;;
  (use-package auto-complete-verilog
    :requires auto-complete
    :quelpa (auto-complete-verilog
             :fetcher wiki
             :files ("auto-complete-verilog.el"))))


(provide 'modes/verilog)
;;; verilog.el ends here
