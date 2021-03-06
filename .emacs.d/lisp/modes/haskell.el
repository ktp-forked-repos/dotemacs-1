;;; haskell.el --- initializes Haskell modes -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defun user--generic-haskell-mode-hook ()
  "Generic Haskell mode hook."
  (turn-on-haskell-doc-mode)

  ;; Enable editing of camel case
  (subword-mode t)

  (user/smartparens-enable)

  (cond
   ((user/auto-complete-p)
    (with-feature 'ac-ghc-mod
      (add-ac-sources 'ac-source-ghc-module 'ac-source-ghc-symbol
                      'ac-source-ghc-pragmas 'ac-source-ghc-langexts)))
   ((user/company-mode-p)
    (with-feature 'company-ghc
      (add-company-sources 'company-ghc))))

  ;;; (Bindings) ;;;
  (user/bind-key-local :doc :reference 'hoogle))


(defun user--haskell-mode-hook ()
  "Haskell mode hook."
  (user--generic-haskell-mode-hook)
  (if (feature-p 'hi2)
      (turn-on-hi2)
    (turn-on-haskell-indentation))

  (with-feature 'ghc
    (ghc-init))

  (with-feature 'shm
    (structured-haskell-mode t)))


(defun user--inferior-haskell-mode-hook ()
  "Inferior Haskell mode hook."
  (user--generic-haskell-mode-hook)

  (turn-on-ghci-completion))

(use-package haskell-mode
  :if (executable-find "ghc")
  :hook ((haskell-mode-hook . user--haskell-mode-hook)
         (inferior-haskell-mode-hook . user--inferior-haskell-mode-hook))
  :config
  ;;; (Packages) ;;;
  (use-package ghci-completion)
  (use-package hi2)
  (use-package flycheck-hdevtools)
  (use-package flycheck-haskell)
  (use-package structured-haskell-mode
    :requires haskell-mode
    :quelpa (structured-haskell-mode
             :fetcher github
             :repo "chrisdone/structured-haskell-mode"
             :files ("elisp/*.el")))
  (use-package ghc-mod
    :if (executable-find "ghc-mod")
    :quelpa (ghc-mod
             :fetcher github
             :repo "kazu-yamamoto/ghc-mod"
             :files ("elisp/*.el")))
  (use-package ac-ghc-mod
    :if (executable-find "ghc-mod")
    :after (auto-complete)
    :requires auto-complete
    :quelpa (ac-ghc-mod
             :fetcher github
             :repo "Pitometsu/ac-ghc-mod"))
  (use-package flycheck-ghcmod
    :if (executable-find "ghc-mod"))
  (use-package company-ghc
    :after (company))
  (use-package lsp-haskell
    :if (executable-find "hie")
    :hook (haskell-mode-hook . lsp-haskell-enable)))


(provide 'modes/haskell)
;;; haskell.el ends here
