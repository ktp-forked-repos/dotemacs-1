;;; cedet.el --- initializes CEDET
;;; Commentary:
;;; Code:

(defun user/cedet-hook ()
  "Hook for modes with CEDET support."
  ;; Use semantic as a source for auto complete
  (when (el-get-package-is-installed 'auto-complete)
    (set (make-local-variable 'ac-sources)
         (append ac-sources '(ac-source-semantic))))

  ;;; (Bindings) ;;;
  (define-key user/code-map (kbd "c") 'user/ede-compile)

  (define-key user/code-map (kbd "RET") 'semantic-ia-complete-symbol)
  (define-key user/code-map (kbd "TAB") 'semantic-ia-complete-symbol-menu)
  (define-key user/code-map (kbd ">") 'semantic-complete-analyze-inline)
  (define-key user/code-map (kbd "=") 'semantic-decoration-include-visit)

  (define-key user/navigation-map (kbd "j") 'semantic-ia-fast-jump)
  (define-key user/navigation-map (kbd "b") 'semantic-mrub-switch-tags)
  (define-key user/navigation-map (kbd "p") 'semantic-analyze-proto-impl-toggle)
  (define-key user/navigation-map (kbd "r") 'semantic-symref)

  (define-key user/documentation-map (kbd "d") 'semantic-ia-show-doc)
  (define-key user/documentation-map (kbd "s") 'semantic-ia-show-summary)

  (local-set-key (kbd "C-c +") 'semantic-tag-folding-show-block)
  (local-set-key (kbd "C-c -") 'semantic-tag-folding-fold-block)
  (local-set-key (kbd "C-c C-c +") 'semantic-tag-folding-show-all)
  (local-set-key (kbd "C-c C-c -") 'semantic-tag-folding-fold-all))


(defun user/cedet-before-init ()
  "Setup before loading CEDET."
  (setq-default
   ;; Set up paths to caches
   semanticdb-default-save-directory (path-join *user-cache-directory* "semanticdb")
   ede-project-placeholder-cache-file (path-join *user-cache-directory* "ede-projects.el")
   srecode-map-save-file (path-join *user-cache-directory* "srecode-map.el")))


(defun user/cedet-init ()
  "Initialize CEDET."
  ;;; (EDE) ;;;
  (global-ede-mode t)
  (ede-enable-generic-projects)

  ;;; (Semantic) ;;;
  (require 'semantic/ia)
  (require 'semantic/db)

  (semantic-mode)
  (semantic-load-enable-code-helpers)

  ;; Scan source code automatically during idle time
  (global-semantic-idle-scheduler-mode t)
  ;; Initiate inline completion automatically during idle time
  (global-semantic-idle-completions-mode t)
  ;; Show breadcrumbs during idle time
  (setq-default
   semantic-idle-breadcrumbs-format-tag-function 'semantic-format-tag-summarize
   semantic-idle-breadcrumbs-separator " ⊃ "
   semantic-idle-breadcrumbs-header-line-prefix " ≝ ")
  (global-semantic-idle-breadcrumbs-mode t)

  ;; Enable [ec]tags support
  (semantic-load-enable-primary-ectags-support)

  ;; Enable SRecode templates globally
  (global-srecode-minor-mode)

  ;;; (SemanticDB) ;;;
  (global-semanticdb-minor-mode t)

  ;; Check if GNU Global is available
  (when (cedet-gnu-global-version-check t)
    (semanticdb-enable-gnu-global-databases 'c-mode)
    (semanticdb-enable-gnu-global-databases 'c++-mode))

  ;;; (Functions) ;;;
  (defun user/ede-get-current-project ()
    "Get the current EDE project."
    (let* ((fname (or (buffer-file-name (current-buffer)) default-directory))
           (current-dir (file-name-directory fname)))
      (ede-current-project current-dir)))

  (defun user/ede-gen-std-compile-string ()
    "Generate compilation string for standard GNU Make project."
    (let ((project-root (ede-project-root-directory
                         (user/ede-get-current-project))))
      (concat "cd " project-root "; "
              "nice make -j")))

  (defun user/ede-get-local-var (fname var)
    "For file FNAME fetch the value of VAR from project."
    (let ((current-project (user/ede-get-current-project)))
      (when current-project
        (let* ((ov (oref current-project local-variables))
               (lst (assoc var ov)))
          (when lst
            (cdr lst))))))

  (defun user/ede-compile ()
    "Compile using EDE if possible, otherwise revert to compile."
    (interactive)
    (let ((current-project (user/ede-get-current-project)))
      (if current-project
          (project-compile-project current-project)
        (call-interactively 'compile)))))

(require-package '(:name cedet
                         :before (user/cedet-before-init)
                         :after (user/cedet-init)))


(provide 'utilities/cedet)
;;; cedet.el ends here
