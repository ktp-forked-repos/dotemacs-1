;;; glsl.el --- Initializes GLSL mode
;;; Commentary:
;;; Code:

(defun user--glsl-mode-hook ()
  "GLSL mode hook.")


(defun user--glsl-mode-config ()
  "Initialize GLSL mode."
  (add-hook 'glsl-mode-hook 'user--glsl-mode-hook))

(req-package glsl-mode
  :config (user--glsl-mode-config))


(provide 'modes/glsl)
;;; glsl.el ends here
