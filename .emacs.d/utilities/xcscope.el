;;; xcscope.el --- cscope integration
;;; Commentary:
;;; Code:

(defconst *has-cscope* (executable-find "cscope"))


(defun user/xcscope-init ()
  "Initialize xcscope."
  (setq-default
   cscope-index-recursively t)

  ;;; (Faces) ;;;
  (after-load 'solarized-theme
    (solarized-with-values
      (eval
       `(custom-theme-set-faces
         'solarized
         '(cscope-file-face ((t (:foreground ,green :weight bold))))
         '(cscope-function-face ((t (:foreground ,blue))))
         '(cscope-line-number-face ((t (:foreground ,yellow))))
         '(cscope-line-face ((t (:foreground ,solarized-fg))))
         '(cscope-mouse-face ((t (:foreground ,solarized-fg :background ,blue)))))))))


(when *has-cscope*
  (require-package '(:name xcscope
                           :type github
                           :pkgname "dholm/xcscope"
                           :features xcscope
                           :after (user/xcscope-init)
                           :prepare (progn
                                      (setq cscope-indexing-script
                                            (expand-file-name
                                             (concat (el-get-package-directory "xcscope") "cscope-indexer")))))))


(provide 'utilities/xcscope)
;;; xcscope.el ends here
