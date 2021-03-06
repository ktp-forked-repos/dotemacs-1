;;; profiler.el --- Configure Emacs profiler -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defun user--profiler-report-mode-hook ()
  "Profiler report mode hook."
  ;;; (Bindings) ;;;
  (user/bind-key-local :basic :save 'profiler-report-write-profile)
  (user/bind-key-local :basic :save-as 'profiler-report-write-profile))

(use-package profiler
  :defer
  :init
  (add-hook 'profiler-report-mode-hook 'user--profiler-report-mode-hook)

  ;;; (Bindings) ;;;
  (user/bind-key-global :emacs :profiler-start 'profiler-start)
  (user/bind-key-global :emacs :profiler-stop 'profiler-stop)
  (user/bind-key-global :emacs :profiler-report 'profiler-report)
  :config
  (validate-setq
   ;; The maximum number distinct of call-stacks to save.
   profiler-log-size 100000
   ;; Maximum call-stack depth to record.
   profiler-max-stack-depth 32))


(provide 'utilities/profiler)
;;; profiler.el ends here
