;;; jam.el --- Initializes Jam mode
;;; Commentary:
;;; Code:

(defun user/jam-mode-hook ()
  "Initialize Jam mode."
  ;; Use spaces for indent
  (setq indent-tabs-mode nil))


(defun user/jam-mode-init ()
  "Initialize Jam mode."
  (setq-default
   ;; Default indent width.
   jam-indent-size 4)

  (add-hook 'jam-mode-hook 'user/jam-mode-hook)

  (add-auto-mode 'jam-mode "\\.jam$" "Jamfile.*"))

(require-package '(:name jam-mode :after (user/jam-mode-init)))


(provide 'modes/jam)
;;; jam.el ends here