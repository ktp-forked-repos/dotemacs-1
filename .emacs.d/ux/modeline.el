;;; modeline.el --- Modeline configuration
;;; Commentary:
;;; Code:

(defun user/modeline-init ()
  "Initialize Emacs modeline."
  (setq-default
   ;; Show row and column numbers.
   line-number-mode t
   column-number-mode t)

  ;; Display the current time and system load.
  (require 'time)
  (setq-default
   display-time-24hr-format t
   display-time-form-list (list 'time 'load)
   display-time-day-and-date t)
  (display-time)

  (require-package '(:name diminish))
  (require-package '(:name powerline
                           :type github
                           :pkgname "milkypostman/powerline"
                           :after (user/powerline-init)
                           :prepare (autoload 'powerline-default-theme "powerline" nil t))))


(defun user/powerline-init ()
  "Initialize powerline."
  (require 'powerline)

  ;;; (Faces) ;;;
  (after-load 'solarized-theme
    (solarized-with-values
      (eval
       `(custom-theme-set-faces
         'solarized
         '(mode-line ((t (:foreground ,solarized-fg :background ,solarized-comment))))
         '(mode-line-buffer-id ((t (:foreground ,base2 :background ,blue))))
         '(mode-line-inactive ((t (:foreground ,solarized-fg :background ,solarized-comment))))
         '(powerline-active1 ((t (:foreground ,solarized-comment :background ,solarized-hl))))
         '(powerline-active2 ((t (:foreground ,orange :background ,solarized-hl))))
         '(powerline-inactive1 ((t (:foreground ,solarized-fg :background ,solarized-hl))))
         '(powerline-inactive2 ((t (:foreground ,solarized-fg :background ,solarized-comment))))))))

  ;;; (Theme) ;;;
  (setq-default powerline-arrow-shape 'slant)
  (powerline-default-theme))


(user/modeline-init)


(provide 'ux/modeline)
;;; modeline.el ends here