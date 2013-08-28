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
  (define-key user/navigation-map (kbd "s") 'semantic-complete-jump)
  (define-key user/navigation-map (kbd "b") 'semantic-mrub-switch-tags)
  (define-key user/navigation-map (kbd "i") 'semantic-analyze-proto-impl-toggle)
  (define-key user/navigation-map (kbd "r") 'semantic-symref)

  (define-key user/documentation-map (kbd "d") 'semantic-ia-show-doc)
  (define-key user/documentation-map (kbd "s") 'semantic-ia-show-summary))


(defun user/cedet-before-init ()
  "Setup before loading CEDET."
  (setq-default
   ;; Set up paths to caches
   semanticdb-default-save-directory (path-join *user-cache-directory* "semanticdb")
   ede-project-placeholder-cache-file (path-join *user-cache-directory* "ede-projects.el")
   srecode-map-save-file (path-join *user-cache-directory* "srecode-map.el")))


(defun user/cedet-init ()
  "Initialize CEDET."
  ;;; (Semantic) ;;;
  (require 'semantic/ia)

  ;; Scan source code automatically during idle time
  (add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
  ;; Highlight the first line of the current tag
  (add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
  ;; Initiate inline completion automatically during idle time
  (add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)
  ;; Show breadcrumbs during idle time
  (setq-default
   semantic-idle-breadcrumbs-format-tag-function 'semantic-format-tag-summarize
   semantic-idle-breadcrumbs-separator " ⊃ "
   semantic-idle-breadcrumbs-header-line-prefix " ≝ ")
  (add-to-list 'semantic-default-submodes 'global-semantic-idle-breadcrumbs-mode)

  ;; Remember recently edited tags
  (add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)

  ;; Enable [ec]tags support
  (when (cedet-ectag-version-check t)
    (semantic-load-enable-primary-ectags-support))

  ;; Enable semantic
  (semantic-mode t)

  ;;; (SemanticDB) ;;;
  (require 'semantic/db)
  (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)

  (require 'cedet-cscope)
  (when (cedet-cscope-version-check t)
    ;; Use CScope as a database for SemanticDB
    (semanticdb-enable-cscope-databases)
    ;; Use CScope as a source for EDE
    (setq ede-locate-setup-options
	  '(ede-locate-cscope
	    ede-locate-base)))

  ;; Enable GNU Global if available
  (when (cedet-gnu-global-version-check t)
    (semanticdb-enable-gnu-global-databases 'c-mode)
    (semanticdb-enable-gnu-global-databases 'c++-mode)

    (add-to-list 'ac-sources 'ac-source-gtags))

  ;;; (Context Menu) ;;;
  (when (display-graphic-p)
    (add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode)
    (define-key user/code-map (kbd "SPC") 'cedet-m3-menu-kbd))

  ;;; (EDE) ;;;
  (global-ede-mode t)
  (ede-enable-generic-projects)

  ;;; (Functions) ;;;
  (defun user/ede-get-current-project ()
    "Get the current EDE project."
    (let* ((current-file (or (buffer-file-name) default-directory))
           (current-dir (file-name-directory current-file)))
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
        (call-interactively 'compile))))

  (defun user/gnu-global-create/update ()
    "Create or update GNU Global database at current project root."
    (interactive)
    (let* ((current-file (or (buffer-file-name) default-directory))
           (proj-root (user/project-root current-file)))
      (when (and proj-root (cedet-gnu-global-version-check t))
        (cedet-gnu-global-create/update-database proj-root)
        (message (format "GNU/Global database updated at %S" proj-root))))))

(require-package '(:name cedet
                         :before (user/cedet-before-init)
                         :after (user/cedet-init)))


(provide 'utilities/cedet)
;;; cedet.el ends here
