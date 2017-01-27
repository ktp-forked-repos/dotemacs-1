;;; bookmarks.el --- Bookmarks in Emacs
;;; Commentary:
;;; Code:

(defconst *visible-bookmarks-data-file* (path-join *user-data-directory*
                                                   "visible-bookmarks"))
(defconst *bookmark+-data-file* (path-join *user-data-directory* "bookmarks"))
(defconst *bookmark+-menu-state-file* (path-join *user-cache-directory*
                                                 "bookmark-menu-state.el"))


(defun user--visible-bookmarks-config ()
  "Initialize visible bookmarks."
  (setq-default
   ;; Persistent bookmarks.
   bm-repository-file *visible-bookmarks-data-file*
   bm-buffer-persistence t)

  (after-load 'bm
    ;; Restore bookmarks on file find.
    (add-hook 'find-file-hooks 'bm-buffer-restore)
    ;; Save bookmarks when killing buffer.
    (add-hook 'kill-buffer-hook 'bm-buffer-save)
    ;; Save all bookmarks on exit.
    (add-hook 'kill-emacs-hook 'bm-save)
    ;; Update repository when saving file.
    (add-hook 'after-save-hook 'bm-buffer-save)
    ;; Restore bookmarks when buffer is reverted.
    (add-hook 'after-revert-hook 'bm-buffer-restore))

  ;;; (Bindings) ;;;
  (user/bind-key-global :code :bookmark-toggle 'bm-toggle)
  (user/bind-key-global :code :bookmark-next 'bm-next)
  (user/bind-key-global :code :bookmark-prev 'bm-previous))


(defun user--bookmark+-init ()
  "Setup before loading bookmark+."
  (setq-default
   ;; Enable versioned backups.
   bookmark-version-control t
   ;; Save bookmarks after ten updates.
   bmkp-count-multi-mods-as-one-flag t
   bookmark-save-flag 1
   ;; Put the menu state in the cache directory.
   bmkp-bmenu-state-file *bookmark+-menu-state-file*
   ;; Put the repository in the data directory.
   bookmark-default-file *bookmark+-data-file*))


(defun user--bookmark+-config ()
  "Initialize bookmark+."
  ;;; (Bindings) ;;;
  ;; Bind bookmarks to C-c b
  (global-set-key (user/get-key :code :bookmark-prefix) 'bookmark-map)

  (define-key bookmark-map (kbd "l") 'bookmark-jump)
  (define-key bookmark-map (kbd "e") 'bmkp-edit-bookmark-record)
  (define-key bookmark-map (kbd "t") 'bmkp-add-tags))


(defun user--bookmarks-config ()
  "Initialize bookmarks in Emacs."
  ;;; (Packages) ;;;
  (req-package bm
    :config (user--visible-bookmarks-config))
  (req-package bookmark+
    :init (user--bookmark+-init)
    :config (user--bookmark+-config)))

(user--bookmarks-config)


(provide 'utilities/bookmarks)
;;; bookmarks.el ends here
