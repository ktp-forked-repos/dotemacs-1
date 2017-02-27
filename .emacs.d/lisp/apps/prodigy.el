;;; prodigy.el --- Emacs service manager. -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(use-package prodigy
  :commands prodigy
  :init
  (user/bind-key-global :apps :services 'prodigy))


(provide 'apps/prodigy)
;;; prodigy.el ends here
