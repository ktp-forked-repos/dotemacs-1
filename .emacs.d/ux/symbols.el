;;; symbols.el --- Configure how Emacs handles certain symbols
;;; Commentary:
;;; Code:

(defun user/symbols-init ()
  "Initialize Emacs symbol handling."
  ;;; (Packages) ;;;
  (require-package '(:name page-break-lines :after (user/page-break-lines-init)))

  (require 'ux/coding)
  (when (eq default-terminal-coding-system 'utf-8)
    (require-package '(:name pretty-mode-plus
                             :type github
                             :pkgname "akatov/pretty-mode-plus"
                             :prepare (progn
                                        (autoload 'turn-on-pretty-mode "pretty-mode-plus")
                                        (autoload 'global-pretty-mode "pretty-mode-plus"))
                             :after (user/pretty-mode-plus-init)))))


(defun user/page-break-lines-init ()
  "Initialize page break lines."
  (require 'page-break-lines)
  (global-page-break-lines-mode)
  (after-load 'diminish
    (diminish 'page-break-lines-mode)))


(defun user/pretty-mode-plus-init ()
  "Initialize pretty mode plus."
  ;;; (Faces) ;;;
  (after-load 'solarized-theme
    (solarized-with-values
      (eval
       `(custom-theme-set-faces
         'solarized
         '(pretty-mode-symbol-face  ((t (:foreground ,green))))))))

  ;; Enable pretty mode plus globally
  (global-pretty-mode t))


(user/symbols-init)


(provide 'ux/symbols)
;;; symbols.el ends here
