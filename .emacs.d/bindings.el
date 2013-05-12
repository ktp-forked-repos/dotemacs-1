;; (Key Bindings) ;;

;; Function keys
(when (display-graphic-p)
  (global-set-key [f2] 'minimap-toggle))
(global-set-key [f3] 'multi-term-dedicated-toggle)
(global-set-key [f7] 'compile)
(global-set-key [f8] 'gdb)


;; Alias C-x C-m to M-x which is a bit awkward to reach
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)


;; Delete words with C-w and rebind kill region to C-x C-k
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)


;; Spell check the current word
(global-set-key "\C-c\C-w" 'ispell-word)


;; Use regex searches by default
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "\C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)


;; Resizing windows
(global-set-key (kbd "C-c <up>") 'shrink-window)
(global-set-key (kbd "C-c <down>") 'enlarge-window)
(global-set-key (kbd "C-c <left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-c <right>") 'enlarge-window-horizontally)
