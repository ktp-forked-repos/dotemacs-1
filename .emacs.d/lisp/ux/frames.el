;;; frames.el --- Configure behavior of Emacs frames -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defun user--window-configuration-change-hook ()
  "Window configuration change hook."
  (setq
   ;; Only split frame if it occupies at least 2/3 of the current screen width.
   split-width-threshold (* (/ (window-total-width (frame-root-window)) 3) 2)))

(defun user/iconify-or-deiconify-frame ()
  "Iconify the selected frame, or deiconify if it's currently an icon."
  (interactive)
  (if (display-graphic-p)
      (iconify-or-deiconify-frame)
    (suspend-frame)))


(defun user/close-and-kill-current-window ()
  "If multiple windows are open, close the current one and kill the buffer."
  (interactive)
  (kill-this-buffer)
  (if (not (one-window-p))
      (delete-window)))


(defun user/close-and-kill-other-window ()
  "If multiple windows are open, close the next one and kill its buffer."
  (interactive)
  (other-window 1)
  (kill-this-buffer)
  (if (not (one-window-p))
      (delete-window)))

(progn
  (validate-setq
   ;; Inhibit GUI features
   use-file-dialog nil
   ;; Don't split frames horizontally.
   split-height-threshold nil)

  ;; Remove all the mouse-assisted frames
  (when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
  (when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
  (when (fboundp 'menu-bar-mode) (menu-bar-mode -1))

  ;;; (Hooks) ;;;
  (add-to-list 'window-configuration-change-hook
               'user--window-configuration-change-hook)

  ;;; (Bindings) ;;;
  (when (display-graphic-p)
    (user/bind-key-global :emacs :fullscreen 'toggle-frame-fullscreen))

  (user/bind-key-global :emacs :grow-vertical 'enlarge-window)
  (user/bind-key-global :emacs :shrink-vertical 'shrink-window)
  (user/bind-key-global :emacs :grow-horizontal 'enlarge-window-horizontally)
  (user/bind-key-global :emacs :shrink-horizontal 'shrink-window-horizontally)

  ;;; (Packages) ;;;
  (use-package fullframe)
  (use-package transpose-frame
    :defer
    :init
    (user/bind-key-global :emacs :flip-frame 'flip-frame)
    (user/bind-key-global :emacs :flop-frame 'flop-frame)
    (user/bind-key-global :emacs :rotate-frame-forward 'rotate-frame-clockwise)
    (user/bind-key-global :emacs :rotate-frame-backward
                          'rotate-frame-anticlockwise))
  (use-package zoom
    :diminish zoom-mode
    :config
    (validate-setq
     ;; Ignored buffers.
     zoom-ignored-buffer-name-regexps
     '("^*calc")
     ;; Ignore predicate definitions.
     zoom-ignore-predicates
     '((lambda () (> (count-lines (point-min) (point-max)) 20))))

    (zoom-mode t))

  (use-package frame
    :ensure nil
    :config
    ;; Enable blinking cursor
    (blink-cursor-mode)))


(provide 'ux/frames)
;;; frames.el ends here
