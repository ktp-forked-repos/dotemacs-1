;;; scrolling.el --- Configure scrolling in Emacs buffers
;;; Commentary:
;;; Code:

(defun user/scrolling-init ()
  "Configure Emacs buffer scrolling."
  (setq-default
   ;; Start scrolling on first or last line.
   scroll-margin 0
   ;; Prevent cursor from jumping to center of window on scroll.
   scroll-conservatively 100000
   ;; Try to maintain screen position when scrolling entire pages.
   scroll-preserve-screen-position t
   ;; Scroll five lines when using mouse wheel.
   mouse-wheel-scroll-amount '(5 ((shift) . 5))
   ;; Use constant speed when scrolling with mouse wheel.
   mouse-wheel-progressive-speed nil
   ;; Scroll the window that the cursor is over.
   mouse-wheel-follow-mouse t))


(user/scrolling-init)


(provide 'ux/scrolling)
;;; scrolling.el ends here
