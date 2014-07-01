;;; growl.el --- Growl notification support
;;; Commentary:
;;; Code:

(defun user/growl-init ()
  "Initialize Growl support for Emacs."
  (require-package '(:name growl)))

(when (osx-app-installed-p "com.growl.growlhelperapp")
  (user/growl-init))


(provide 'utilities/growl)
;;; growl.el ends here