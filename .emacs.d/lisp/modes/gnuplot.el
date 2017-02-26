;;; gnuplot --- initializes gnuplot mode
;;; Commentary:
;;; Code:

(with-executable 'gnuplot
  (use-package gnuplot-mode
    :defer
    :init
    (add-auto-mode 'gnuplot-mode "\\.gp$")))


(provide 'modes/gnuplot)
;;; gnuplot.el ends here
