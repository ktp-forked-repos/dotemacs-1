;;; erlang.el --- Erlang mode support
;;; Commentary:
;;; Code:

(defun user--erlang-mode-hook ()
  "Erlang mode hook."
  (user/gnu-global-enable)

  (with-feature 'rainbow-delimiters
    ;; Enable rainbow delimiters.
    (rainbow-delimiters-mode t))

  (with-feature 'distel
    ;; Enable erlang node integration.
    (erlang-extended-mode t))

  (with-feature 'edts-mode
    ;; Enable Erlang Development Tool Suite.
    (edts-mode t))

  (with-feature 'wrangler
    ;; Enable wrangler refactoring tool.
    (erlang-wrangler-on))

  ;; Enable YouCompleteMe.
  (user/ycmd-enable)

  ;; Bring in CEDET.
  (user--cedet-hook))


(defun user--elixir-mode-hook ()
  "Erlang Elixir mode hook."
  (user--erlang-mode-hook)

  (with-feature 'alchemist
    (alchemist-mode t)))


(defun user--erlang-mode-config ()
  "Initialize Erlang mode."
  ;;; (Hooks) ;;;
  (add-hook 'erlang-mode-hook 'user--erlang-mode-hook)
  (add-hook 'elixir-mode-hook 'user--elixir-mode-hook)

  (after-load 'erlang-mode
    (with-feature 'edts
      (require 'edts-start))

    (with-feature 'distel
      (distel-setup))))

(with-executable 'erl
  (req-package erlang
    :after (user--erlang-mode-config))
  (req-package edts)
  (req-package distel
    :loader :el-get)
  (req-package wrangler
    :loader :el-get)
  (req-package alchemist))

(provide 'modes/erlang)
;;; erlang.el ends here
