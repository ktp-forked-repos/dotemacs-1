;;; sauron.el --- Emacs event tracker -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(use-package sauron
  :defer
  :init
  (user/bind-key-global :util :notifications 'sauron-toggle-hide-show)
  :config
  (validate-setq
   ;; Display sauron in current frame.
   sauron-separate-frame nil))


(provide 'utilities/sauron)
;;; sauron.el ends here
