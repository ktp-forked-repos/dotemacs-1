;;; browser.el --- Web browsing.
;;; Commentary:
;;; Code:

(defconst *user-w3m-data-directory*
  (path-join *user-data-directory* "w3m")
  "Path to user's w3m data store.")

(defconst *user-w3m-cache-directory*
  (path-join *user-cache-directory* "w3m")
  "Path to user's w3m cache store.")


(defun user/w3m-display-hook (url)
  "W3M display hook for URL."
  (rename-buffer
   (format "*w3m: %s*" (or w3m-current-title w3m-current-url)) t)
  (let ((buffer-read-only nil))
    ;; Remove trailing whitespace when browsing.
    (delete-trailing-whitespace)))


(defun user/w3m-init ()
  "Initialize w3m."
  (setq-default
   ;; Set up data paths.
   w3m-bookmark-file (path-join *user-w3m-data-directory* "bookmarks.html")
   ;; Set up cache paths.
   w3m-cookie-file (path-join *user-w3m-cache-directory* "cookies")
   w3m-session-file (path-join *user-w3m-cache-directory* "sessions")
   ;; Use cookies.
   w3m-use-cookies t
   w3m-cookie-accept-bad-cookies t
   ;; Default to UTF-8 encoding.
   w3m-coding-system 'utf-8
   w3m-file-coding-system 'utf-8
   w3m-file-name-coding-system 'utf-8
   w3m-input-coding-system 'utf-8
   w3m-output-coding-system 'utf-8
   w3m-terminal-coding-system 'utf-8
   ;; Automatically restore crashed sessions.
   w3m-session-load-crashed-sessions t
   ;; Display page title in header line.
   w3m-use-header-line-title t
   ;; Use UTF-8 to display nicer tables.
   w3m-default-symbol
   '("─┼" " ├" "─┬" " ┌" "─┤" " │" "─┐" ""
     "─┴" " └" "──" ""   "─┘" ""   ""   ""
     "─┼" " ┠" "━┯" " ┏" "─┨" " ┃" "━┓" ""
     "━┷" " ┗" "━━" ""   "━┛" ""   ""   ""
     " •" " □" " ☆" " ○" " ■" " ★" " ◎"
     " ●" " △" " ●" " ○" " □" " ●" "≪ ↑ ↓ "))

  (when (display-graphic-p)
    (setq-default
     ;; Display graphics in pages.
     w3m-toggle-inline-images-permanently t
     w3m-default-display-inline-images t
     ;; Show favicons.
     w3m-use-favicon t
     w3m-favicon-use-cache-file t
     ;; Show graphical status indicator in mode line.
     w3m-show-graphic-icons-in-mode-line t))

  (autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)

  (add-hook 'w3m-display-hook 'user/w3m-display-hook))


(defun user/browser-init ()
  "Initialize web browsing in Emacs."
  (with-executable 'w3m
    (require-package '(:name emacs-w3m :after (user/w3m-init))))

  ;; Set the default web browser.
  (setq-default browse-url-browser-function
                (cond
                 ((featurep 'eww) 'eww-browse-url)
                 ((executable-find "w3m") 'w3m-browse-url)
                 (t 'browse-url-default-browser)))

  ;;; (Bindings) ;;;
  (user/bind-key-global :apps :browser 'w3m)
  (user/bind-key-global :nav :open 'browse-url-at-point))

(user/browser-init)


(provide 'apps/browser)
;;; browser.el ends here
