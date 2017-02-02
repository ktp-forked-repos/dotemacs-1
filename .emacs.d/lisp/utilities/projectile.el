;;; projectile.el --- Projectile project management
;;; Commentary:
;;; Code:

(defun user--projectile-config ()
  "Initialize projectile."
  (validate-setq
   ;; Projectile bookmarks.
   projectile-known-projects-file (path-join *user-data-directory*
                                             "projectile-bookmarks.eld")
   ;; Projectile cache store.
   projectile-cache-file (path-join *user-cache-directory* "projectile")
   ;; Use default completion that will usually be provided by Helm.
   projectile-completion-system 'default
   ;; Enable in smart mode line.
   sml/use-projectile-p 'after-prefixes)

  (with-executable 'ctags-exuberant
    (validate-setq
     ;; Default to exuberant ctags.
     projectile-tags-command "ctags-exuberant -Re %s"))

  ;; Enable projectile globally.
  (projectile-global-mode)

  ;;; (Bindings) ;;;
  (user/bind-key-global :basic :open-file-context 'projectile-find-file))

(use-package projectile
  :defer t
  :diminish projectile-mode
  :config (user--projectile-config))


(provide 'utilities/projectile)
;;; projectile.el ends here
