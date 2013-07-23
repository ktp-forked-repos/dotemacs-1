;;; pretty-mode-plus --- pretty-print special sequences
;;; Commentary:
;;; Code:

(require-package '(:name pretty-mode-plus
			 :type elpa
			 :repo ("marmalade" . "http://marmalade-repo.org/packages/")
			 :after (dholm/pretty-mode-plus-init)))

(defun dholm/pretty-mode-plus-init ()
  (require 'pretty-mode-plus)
  (global-pretty-mode))


(provide 'ux/pretty-mode-plus)
;;; pretty-mode-plus.el ends here
