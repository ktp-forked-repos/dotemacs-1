;;; erlang.el --- Erlang mode support -*- lexical-binding: t; -*-
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

  ;; Bring in CEDET.
  (user--cedet-hook))


(defun user--elixir-mode-hook ()
  "Erlang Elixir mode hook."
  (user--erlang-mode-hook)

  (with-feature 'alchemist
    (alchemist-mode t)))


(with-executable 'erl
  (use-package erlang
    :defer
    :init
    (add-hook 'erlang-mode-hook 'user--erlang-mode-hook)
    (add-hook 'elixir-mode-hook 'user--elixir-mode-hook)
    :config
    (use-package edts
      :pin "MELPA")
    (require 'edts-start)

    (with-feature 'distel
      (distel-setup))

    (use-package alchemist)
    (use-package distel
      :quelpa (distel
               :fetcher github
               :repo "massemanet/distel"
               :files ("elisp/*.el")))))


(provide 'modes/erlang)
;;; erlang.el ends here
