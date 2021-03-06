;;; bindings.el --- Smart VCS bindings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defvar user/vcs-command-alist
  '((:Git . ((:clone . magit-clone)
             (:status . magit-status)
             (:history . magit-file-log)
             (:version . magit-show)
             (:describe . git-messenger:popup-message)
             (:gutter . git-gutter:toggle)
             (:review . (lambda ()
                          ;; Make it non-interactive to pick the current repo.
                          (gerrit-download)))
             (:add-buffer . (lambda ()
                              (magit-run-git "add" (path-abs-buffer))))
             (:mergetool . magit-ediff)
             (:search . helm-git-grep)
             (:find-file . magit-find-file-completing-read)
             (:time-machine . (lambda ()
                                (when (feature-p 'git-timemachine)
                                  (call-interactively 'git-timemachine))))))
    (:ClearCase . ((:status . (lambda ()
                                (vc-dir (path-abs-buffer))))
                   (:history . vc-print-log)
                   (:version . vc-revision-other-window)
                   (:describe . vc-annotate)
                   (:gutter . diff-hl-margin-mode)
                   (:add-buffer . vc-register)
                   (:next-action . vc-next-action)
                   (:mergetool . vc-resolve-conflicts)))))


(defun user/vcs-command-group (file-name)
  "Get the appropriate command group for FILE-NAME."
  (let ((backend (vc-responsible-backend file-name)))
    (cond ((eq backend 'Git)
           (cdr (assq :Git user/vcs-command-alist)))
          ((eq backend 'CLEARCASE)
           (cdr (assq :ClearCase user/vcs-command-alist))))))


(defun user/vcs-command (command)
  "Run VCS COMMAND on current buffer."
  (let ((group (user/vcs-command-group (path-abs-buffer))))
    (when (and group (assq command group))
      (if (interactive-form (cdr (assq command group)))
          (call-interactively (cdr (assq command group)))
        (funcall (cdr (assq command group)))))))


(defun user/vcs-clone ()
  "Execute VCS clone command."
  (interactive)
  (user/vcs-command :clone))


(defun user/vcs-status ()
  "Execute VCS status command on the current buffer."
  (interactive)
  (user/vcs-command :status))


(defun user/vcs-history ()
  "Execute VCS history command on the current buffer."
  (interactive)
  (user/vcs-command :history))


(defun user/vcs-version ()
  "Execute VCS version command on the current buffer."
  (interactive)
  (user/vcs-command :version))


(defun user/vcs-describe ()
  "Execute VCS describe command on the current buffer."
  (interactive)
  (user/vcs-command :describe))


(defun user/vcs-gutter ()
  "Execute VCS gutter command on the current buffer."
  (interactive)
  (user/vcs-command :gutter))


(defun user/vcs-review ()
  "Execute VCS code review command on the current buffer."
  (interactive)
  (user/vcs-command :review))


(defun user/vcs-next-action ()
  "Execute next VCS action on the current buffer."
  (interactive)
  (user/vcs-command :next-action))


(defun user/vcs-add-buffer ()
  "Add the current buffer to VCS."
  (interactive)
  (user/vcs-command :add-buffer))


(defun user/vcs-mergetool ()
  "Run VCS mergetool on the current buffer."
  (interactive)
  (user/vcs-command :mergetool))


(defun user/vcs-search ()
  "Run VCS time machine on the current buffer."
  (interactive)
  (user/vcs-command :search))


(defun user/vcs-find-file ()
  "Run VCS find file on the current buffer."
  (interactive)
  (user/vcs-command :find-file))


(defun user/vcs-time-machine ()
  "Run VCS time machine on the current buffer."
  (interactive)
  (user/vcs-command :time-machine))


(defun user--vcs-bindings-config ()
  "Initialize smart VCS bindings."
  ;; Need autoload for bindings to work.
  (autoload 'vc-responsible-backend "vc.el")

  ;;; (Bindings) ;;;
  (user/bind-key-global :vcs :clone 'user/vcs-clone)
  (user/bind-key-global :vcs :status 'user/vcs-status)
  (user/bind-key-global :vcs :history 'user/vcs-history)
  (user/bind-key-global :vcs :version 'user/vcs-version)
  (user/bind-key-global :vcs :describe 'user/vcs-describe)
  (user/bind-key-global :vcs :gutter 'user/vcs-gutter)
  (user/bind-key-global :vcs :review 'user/vcs-review)

  (user/bind-key-global :vcs :next-action 'user/vcs-next-action)
  (user/bind-key-global :vcs :add-buffer 'user/vcs-add-buffer)
  (user/bind-key-global :vcs :mergetool 'user/vcs-mergetool)

  (user/bind-key-global :vcs :search 'user/vcs-search)
  (user/bind-key-global :vcs :find-file 'user/vcs-find-file)
  (user/bind-key-global :vcs :time-machine 'user/vcs-time-machine))

(user--vcs-bindings-config)


(provide 'vcs/bindings)
;;; bindings.el ends here
