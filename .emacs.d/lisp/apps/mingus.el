;;; mingus.el --- MPD frontend for Emacs -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(when (fboundp 'define-fringe-bitmap)
  (use-package mingus
    :defer
    :init
    (user/bind-key-global :apps :music 'mingus)))


(provide 'apps/mingus)
;;; mingus.el ends here
