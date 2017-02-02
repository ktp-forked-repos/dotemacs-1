;;; request.el --- interface to The Silver Searcher
;;; Commentary:
;;; Code:

(defun user--request-config ()
  "Initialize request."
  (validate-setq
   ;; Request cache store.
   request-storage-directory (path-join *user-cache-directory* "request")))

(use-package request
  :defer t
  :config (user--request-config))


(provide 'utilities/request)
;;; request.el ends here
