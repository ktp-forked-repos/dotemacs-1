;;; lua.el --- Lua mode support
;;; Commentary:
;;; Code:

(defconst *has-lua* (executable-find "lua"))


(defun user/lua-mode-hook ()
  "Lua mode hook."
  (when (el-get-package-is-installed 'lua-block)
    (lua-block-mode t))

  ;; Register file types with find-file-in-project
  (when (el-get-package-is-installed 'find-file-in-project)
    (user/ffip-local-patterns "*.lua")))


(defun user/lua-mode-init ()
  "Initialize Lua mode."
  (require-package '(:name lua-block
                           :type emacswiki
                           :website "https://raw.github.com/emacsmirror/emacswiki.org/master/lua-block.el"
                           :depends (lua-mode)
                           :prepare (progn
                                      (autoload 'lua-block-mode "lua-block" nil
                                        t))))

  (add-hook 'lua-mode-hook 'user/lua-mode-hook))

(when *has-lua*
  (require-package '(:name lua-mode :after (user/lua-mode-init))))


(provide 'modes/lua)
;;; lua.el ends here
