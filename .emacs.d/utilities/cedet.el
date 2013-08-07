;;; cedet.el --- initializes CEDET
;;; Commentary:
;;; Code:

(defun user/cedet-hook ()
  "Hook for modes with CEDET support."
  ;; Set up local bindings
  (define-key user/code-map (kbd "RET") 'semantic-ia-complete-symbol)
  (define-key user/code-map (kbd "?") 'semantic-ia-complete-symbol-menu)
  (define-key user/code-map (kbd ">") 'semantic-complete-analyze-inline)
  (define-key user/code-map (kbd "=") 'semantic-decoration-include-visit)
  (define-key user/navigation-map (kbd "j") 'semantic-ia-fast-jump)
  (define-key user/navigation-map (kbd "b") 'semantic-mrub-switch-tags)
  (define-key user/navigation-map (kbd "p") 'semantic-analyze-proto-impl-toggle)
  (define-key user/documentation-map (kbd "r") 'semantic-symref)
  (define-key user/documentation-map (kbd "d") 'semantic-ia-show-doc)
  (define-key user/documentation-map (kbd "s") 'semantic-ia-show-summary)
  (local-set-key (kbd "C-c +") 'semantic-tag-folding-show-block)
  (local-set-key (kbd "C-c -") 'semantic-tag-folding-fold-block)
  (local-set-key (kbd "C-c C-c +") 'semantic-tag-folding-show-all)
  (local-set-key (kbd "C-c C-c -") 'semantic-tag-folding-fold-all)

  ;; Use semantic as a source for auto complete
  (when (featurep 'auto-complete)
    (set (make-local-variable 'ac-sources)
       (append ac-sources '(ac-source-semantic)))))


(defun user/cedet-before-init ()
  "Setup before loading CEDET."
  (setq-default
   ;; Set up paths to caches
   semanticdb-default-save-directory (path-join *user-cache-directory* "semanticdb")
   ede-project-placeholder-cache-file (path-join *user-cache-directory* "ede-projects.el")
   srecode-map-save-file (path-join *user-cache-directory* "srecode-map.el")))

(defun user/cedet-init ()
  "Initialize CEDET."
  ;; Set up and enable semantic
  (require 'semantic/ia)
  (require 'semantic/db)

  (semantic-mode)
  (semantic-load-enable-excessive-code-helpers)
  (global-semanticdb-minor-mode)

  ;; Check if GNU Global is available
  (when (cedet-gnu-global-version-check t)
    (semanticdb-enable-gnu-global-databases 'c-mode)
    (semanticdb-enable-gnu-global-databases 'c++-mode))

  ;; Enable [ec]tags support
  (semantic-load-enable-primary-ectags-support)

  ;; Enable SRecode templates globally
  (global-srecode-minor-mode)

  ;; Configure ede-mode project management
  (global-ede-mode t)
  (ede-enable-generic-projects))

(require-package '(:name cedet
                         :before (user/cedet-before-init)
                         :after (user/cedet-init)))


(provide 'utilities/cedet)
;;; cedet.el ends here
