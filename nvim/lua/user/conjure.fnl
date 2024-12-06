;; Evaluation
;;
;; <locallead>eb to evaluate buffer
;; <locallead>ee to evaluate sexp (?)
;; <locallead>er to evaluate the outer sexp.
;
;(do                                   ; Level 1 (outermost)
;  (let [x 10]                         ; Level 2
;    (if (> x 5)                       ; Level 3
;      (do                             ; Level 4
;        (print "x is greater than 5") ; Level 5
;        (+ x 20))                     ; Level 5
;      (print "x is small")))          ; Level 3
;  (print "done"))                     ; Level 2
;
;; We can also evaluate a form and replace it with the result of the evaluation
;; with <localleader>e!
;;
;; Evaluated code is saved into a 'c' register which is called through '"cp'.
;; 
;; You can also evaluate at marks. Make a mark inside a code, then evauate my
;; using <locallead>em*letter of the mark*.
;; If you use a capital letter like mF you can even open a different file and
;; evaluate that marked form without changing buffers!
;;
;; To see content of a variable you can specifically evaluate it using <locallead>ew.
;;
;; You can evaluate a visual selection or motion by using <localleader>E.

;; You can place you cursor anywhere inside this code, then activate the outer
;; sexp evalution and it will evaluate 'do'.

;; Logs
;;
;; You can open the log buffer in a few ways:
;;  * Horizontally - <localleader>ls
;;  * Vertically - <localleader>lv
;;  * New tab - <localleader>lt
;;
;; All visible log windows (including the HUD) can be closed with <localleader>lq
;; If you ever need to clear your log you can use the reset mappings:
;; * Soft reset (leaves windows open) - <localleader>lr
;; * Hard reset (closes windows, deletes the buffer) - <localleader>lR




(set vim.g.conjure#client#fennel#aniseed#deprecation_warning false)

(set vim.g.conjure#mapping#prefix "<leader>")

(vim.keymap.set :n :gK "<cmd>ConjureDocWord<CR>"
                {:desc "Get documentation under cursor"})

(vim.keymap.set :n :K "<cmd>vim.lsp.buf.hover<CR>"
                {:desc "Get documentation under cursor"})
