;;; cmake.el --- Initializes CMake mode -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defun user--cmake-mode-hook ()
  "Initialize makefile mode."
  (unless (derived-mode-p 'prog-mode)
    (user--prog-mode-hook))

  ;; Separate camel-case into separate words.
  (subword-mode t))

(use-package cmake-mode
  :if (executable-find "cmake")
  :defer
  :init
  (add-hook 'cmake-mode-hook 'user--cmake-mode-hook)

  (add-auto-mode 'cmake-mode "CMakeLists\\.txt$")
  (add-auto-mode 'cmake-mode "\\.cmake$"))


(provide 'modes/cmake)
;;; cmake.el ends here
