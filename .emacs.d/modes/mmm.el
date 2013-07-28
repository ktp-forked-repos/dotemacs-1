;;; mmm --- initializes "multiple major modes"
;;; Commentary:
;;; Code:

(defun dholm/mmm-mode-init ()
  "Initialize multiple major modes."
  (setq mmm-global-mode 'maybe
        mmm-submode-decoration-level 2))

(require-package '(:name mmm-mode :after (dholm/mmm-mode-init)))


(provide 'modes/mmm)
;;; mmm.el ends here
