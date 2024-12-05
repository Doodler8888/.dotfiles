(in-package :lem-user) ;; Allows to use lem's functions
;; Keybindings
;;
;; Describe symbol: 'C-c C-d d' (lisp-describe-symbol)
;;
;; If a floating window gets stuck, try 'C-z d' keybinding (doesn't work actually)
;;
;; To look inside a function use 'M-.' (find-definitions)
;;
;; -- evaluate --
(define-key lem-vi-mode:*normal-keymap* "Space e e" 'lem-lisp-mode/internal::lisp-eval-expression-in-repl)
(define-key lem-vi-mode:*normal-keymap* "Space e d" 'lem-lisp-mode/eval::lisp-eval-defun)
(define-key lem-vi-mode:*visual-keymap* "Space e r" 'lem-lisp-mode/eval::lisp-eval-region)
(define-key lem-vi-mode:*normal-keymap* "Space e b" 'lem-lisp-mode/eval::lisp-eval-buffer)
(define-key lem-vi-mode:*normal-keymap* "Space e s" 'lem-lisp-mode/eval::lisp-eval-string)
(define-key lem-vi-mode:*normal-keymap* "Space e p" 'lem-lisp-mode/internal::lisp-listen-in-current-package)
;; -- commenting --
(define-key lem-vi-mode:*visual-keymap* "g c" 'lem/language-mode::comment-or-uncomment-region)
(define-key lem-vi-mode:*normal-keymap* "g c c" 'lem/language-mode::comment-or-uncomment-region)
;; -- describe --
(define-key lem-vi-mode:*normal-keymap* "Space d d" 'lem-lisp-mode/internal::lisp-apropos)
(define-key lem-vi-mode:*normal-keymap* "Space d c" 'apropos-command)
(define-key lem-vi-mode:*normal-keymap* "Space d a" 'lem-lisp-mode/internal::lisp-apropos-all)
(define-key lem-vi-mode:*normal-keymap* "Space d p" 'lem-lisp-mode/internal::lisp-apropos-package)
(define-key lem-vi-mode:*normal-keymap* "Space d s" 'lem-lisp-mode/internal::lisp-describe-symbol)
(define-key lem-vi-mode:*normal-keymap* "Space d S" 'lem-lisp-mode/internal::lisp-search-symbol)
(define-key lem-vi-mode:*normal-keymap* "Space d h" 'lem-lisp-mode/hyperspec::hyperspec-at-point)
(define-key lem-vi-mode:*normal-keymap* "Space d H" 'lem-lisp-mode/hyperspec::hyperspec-lookup)
;;
(define-key lem-vi-mode:*normal-keymap* "Space d k" 'describe-key)
(define-key lem-vi-mode:*normal-keymap* "Space d b" 'describe-bindings)
(define-key lem-vi-mode:*normal-keymap* "Space d m" 'list-modes)
(define-key lem-vi-mode:*normal-keymap* "Space d D" 'documentation-describe-bindings)
;;
(define-key lem-vi-mode:*normal-keymap* "K" 'lem-lisp-mode/autodoc:lisp-autodoc)
;; -- buffers --
(define-key lem-vi-mode:*normal-keymap* "Space f b" 'lem/list-buffers:list-buffers)
(define-key lem-vi-mode:*normal-keymap* "C-Tab" 'previous-buffer)

;; -- line wrap --
(setf (variable-value 'line-wrap :global) nil)







;; A hook is a variable that holds a list of functions that are run at certain times.
(add-hook *prompt-after-activate-hook* ;; Asterix are used to denote a global variable.
          (lambda ()
            (call-command 'lem/prompt-window::prompt-completion nil)))

(add-hook *prompt-deactivate-hook*
          (lambda ()
            (lem/completion-mode:completion-end)))

;; Start in vi-mode
(lem-vi-mode:vi-mode)

;; Start the Lisp REPL in vi insert mode.
(add-hook lem-lisp-mode:*lisp-repl-mode-hook* 'lem-vi-mode/commands:vi-insert)

;; -- line numbers --
;; (lem/line-numbers:toggle-line-numbers)
(setf lem/line-numbers:*relative-line* t)

;; (line-numbers-mode)

(define-command init () ()
  (lem:find-file
   (merge-pathnames "init.lisp" (lem-home))))

(setf (lem:variable-value 'lem-core::highlight-line :global) nil)

;; (variable-value symbol &optional (scope default) (where nil wherep)) 
;;
;; &optional means everything that comes after symbol here is optional. 
;; 'scope' is probably lem's own scoping mechanism. In this case its default value is 'default'.
;; 'where' is the parameter name
;; 'nil' is what where will be if not provided
;; 'wherep' will tell the function if where was provided or not. What it probably means here is that there is an old pattern related to handling nil.
;; Basically you have to create another parameter to evalute a parameter. I will see this pattern in CL constantly.
;;
;; lem: vs lem-core::
;; Single colon : means "external" symbol (publicly accessible)
;; Double colon :: means "internal" symbol (package-private)
;; The quote ' is before the whole lem-core::highlight-line because it's treating that entire thing as a symbol.
;; We're not quoting lem: in lem:variable-value because we want to actually use that function, not refer to it as a symbol.
;; Even though you're in :lem-user package, you still need:
;;
;; lem: because variable-value might not be imported into :lem-user
;; lem-core:: because internal symbols are never imported, you must always reference them explicitly

;;(define-command lem () ()
;;  "Open lem config file"
;;  (find-file ~/.dotfiles/.lem/init.lisp))


;; Problems and notices:
;; 1. Pasting works not the same way as in vim and sometimes gives errors.
;; 2. Redo breaks sometimes.
;; 3. Line cursor isn't transparent.
;; 4. No 'paragraph' as an entity for vim motions.
;; 5. Inside double quotes doesn't work if you outside of them.
;;
;; Floats are staying on the screen without closing.


;; I stopped at trying to figure out how to enable line-numbers-mode
