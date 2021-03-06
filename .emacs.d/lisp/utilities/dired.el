;;; dired.el --- Configuration for dired -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defun user--dired-mode-hook ()
  "Mode hook for dired."
  (with-feature 'async
    ;; Asynchronous operations in dired.
    (dired-async-mode t)))

(use-package dired
  :ensure nil
  :defer
  :config
  (validate-setq
   ;; Always copy recursively without asking.
   dired-recursive-copies 'always
   ;; Ask once when recursively deleting a directory.
   dired-recursive-deletes 'top
   ;; Allow dired to be smart about operations.
   dired-dwim-target t
   ;; Default flags for ls.
   dired-listing-switches "-alh")

  ;;; (Packages) ;;;
  (use-package diredfl)
  (use-package dired-k)
  (use-package async)
  (use-package dired-efap
    :config
    ;;; (Bindings) ;;;
    (define-key dired-mode-map [R] 'dired-efap)
    (when (display-graphic-p)
      (define-key dired-mode-map [down-mouse-1] 'dired-efap-click))
    (with-eval-after-load 'dired
      ;; Load dired-efap when dired is loaded.
      (require 'dired-efap)))
  (use-package all-the-icons-dired
    :if window-system)
  (use-package dired-rsync
    :if (executable-find "rsync")
    :bind (:map dired-mode-map
                ("C-c C-r" . dired-rsync)))
  (use-package dired-recent
    :config
    (validate-setq
     ;; Path to history database.
     dired-recent-directories-file (path-join *user-cache-directory* "dired-history"))

    (dired-recent-mode t))

  ;;; (Bindings) ;;;
  ;; Do not open new buffers when going down or up a directory.
  (define-key dired-mode-map (kbd "<return>") 'dired-find-alternate-file)
  (define-key dired-mode-map (kbd "^") (lambda ()
                                         (interactive)
                                         (find-alternate-file "..")))
  (when (display-graphic-p)
    (define-key dired-mode-map [double-mouse-1] 'dired-find-file)))


(provide 'utilities/dired)
;;; dired.el ends here
