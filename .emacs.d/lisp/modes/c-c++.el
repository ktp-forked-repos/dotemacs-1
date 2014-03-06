;;; c-c++.el --- initializes C/C++ modes
;;; Commentary:
;;; Code:

(defun user/c-mode-common-hook ()
  "C mode common hook."
  ;; Set the default C/C++ code styles
  (setq-default
   c-default-style "K&R"
   c++-default-style "Stroustrup"
   ;; Indent using four spaces
   c-basic-offset 4)

  ;; Load CEDET
  (user/c-mode-cedet-hook)

  ;; Override the indentation level of case labels in the K&R- and
  ;; Stroustrup styles so that they are indented one level beyond
  ;; the switch.
  (c-set-offset 'case-label '+)

  ;; Separate camel-case into separate words
  (subword-mode t)

  ;; Register file types with find-file-in-project
  (after-load 'find-file-in-project
    (user/ffip-local-patterns "*.c" "*.h" "*.cpp" "*.hpp" "*.cc" "*.hh"))

  (when (el-get-package-is-installed 'helm-etags-plus)
    ;; Automatically update tags
    (turn-on-ctags-auto-update-mode))

  (when (el-get-package-is-installed 'helm-gtags)
    ;; Enable helm-gtags which in turn enables auto-update of Global tags
    (helm-gtags-mode t))

  ;; Auto completion
  (when (and *has-clang*
           (el-get-package-is-installed 'clang-complete-async))
    (ac-clang-launch-completion-process)
    (add-ac-sources 'ac-source-clang-async))

  (when *has-gdb*
    (gdb-enable-debug t)
    (user/bind-key-local :debug :start 'gdb)))


(defun user/c-mode-cedet-hook ()
  "C mode CEDET hook."
  (when (featurep 'cedet)
    (user/cedet-hook)

    ;; Load eassist from contrib package
    (unless (featurep 'cedet-contrib-load)
      (load (path-join (el-get-package-directory "cedet") "contrib"
                       "cedet-contrib-load.el")))
    (require 'eassist)
    (user/bind-key-local :nav :switch-spec-impl 'eassist-switch-h-cpp)
    (user/bind-key-local :nav :functions/toc 'eassist-list-methods)

    ;; Load extra semantic helpers
    (require 'semantic/bovine/c)
    (require 'semantic/bovine/gcc)
    (require 'semantic/bovine/clang)))


(defun user/c++-header-file-p ()
  "Return non-nil if in a C++ header."
  (and (string-match "\\.h$"
                   (or (buffer-file-name)
                      (buffer-name)))
     (save-excursion
       (re-search-forward "\\_<class\\_>" nil t))))


(defun user/c-c++-mode-init ()
  "Initialize C/C++ mode."
  (when (and *has-clang* *has-llvm-config*)
    (require-package '(:name clang-complete-async)))

  (add-hook 'c-mode-common-hook 'user/c-mode-common-hook)

  ;; Detect if inside a C++ header file.
  (add-magic-mode 'c++-mode 'user/c++-header-file-p))

(user/c-c++-mode-init)


(provide 'modes/c-c++)
;;; c-c++.el ends here