;;; packaging.el --- initialize package management
;;; Commentary:
;;; Code:

;; Configure ELPA repositories
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)


;; Configure and load el-get
(add-to-list 'load-path (path-join *user-el-get-directory* "el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))


(defvar el-get-packages nil "List of el-get packages to sync.")
(defvar el-get-sources nil "List of package definitions for el-get.")

(when (featurep 'el-get)
  (setq-default
   el-get-user-package-directory (path-join user-emacs-directory "init")
   el-get-verbose t))


(defun require-package (package)
  "Add the specified PACKAGE to el-get-sources."
  (setq el-get-sources (append el-get-sources `(,package))))


(defun user/package-list ()
  "Get the list of registered packages."
  (append el-get-packages
          (mapcar 'el-get-as-symbol (mapcar 'el-get-source-name el-get-sources))))


(defun user/sync-packages ()
  "Sync all required packages."
  (el-get 'sync (user/package-list)))


;; Make sure el-get is registered so that el-get-cleanup doesn't remove it
(require-package '(:name el-get))


(provide 'lib/packaging)
;;; packaging.el ends here
