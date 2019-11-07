(require 'package)

(setq inhibit-startup-message t)   ; No startup message
(setq inhibit-splash-screen t)     ; Or splash screen
(setq initial-scratch-message nil) ; Or scratch message
(setq column-number-mode t)        ; Enable column numbers
(setq mouse-wheel-progressive-speed nil) ; No scroll acceleration
(setq-default fill-column 80)      ; No dumb fill column
(global-linum-mode t)              ; Line numbers

(setq tab-width 2)          ; and 4 char wide for TAB
(setq indent-tabs-mode nil) ; And force use of spaces
(setq c-basic-offset 2)     ; indents 4 chars

(setq wg-prefix-key (kbd "C-c w"))

(set-frame-parameter (selected-frame) 'alpha '(94 91))
(add-to-list 'default-frame-alist '(alpha 90 90))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(indent-tabs-mode nil)
 '(mouse-wheel-progressive-speed nil)
 '(package-selected-packages
   (quote
    (clang-format sr-speedbar dired-git-info gited yafolding elpy windmove yasnippet workgroups2 sublimity matlab-mode)))
 '(tab-width 4))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-hook 'dired-load-hook (function (lambda () (load "dired-x"))))

; dired open all marked files
(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map "F" 'my-dired-find-file)
     (defun my-dired-find-file (&optional arg)
       "Open each of the marked files, or the file under the point, or when prefix arg, the next N files "
       (interactive "P")
       (let* ((fn-list (dired-get-marked-files nil arg)))
         (mapc 'find-file fn-list)))))

;### Line transposing ###
(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "C-c C-u") 'move-line-up)
(global-set-key (kbd "C-c C-d") 'move-line-down)
;### End line transposing ###

;### Macros ###
(fset 'newline-from-anywhere
      (lambda (&optional arg) "Keyboard macro."
        (interactive "p")
        (kmacro-exec-ring-item (quote ([5 return 9] 0 "%d")) arg)))

;(global-unset-key (kbd "C-j"))
(global-set-key (kbd "C-<return>") 'newline-from-anywhere)


(defun save-macro (name)
  "save a macro. Take a name as argument
     and save the last defined macro under
     this name at the end of your .emacs"
  (interactive "SName of the macro: ")  ; ask for the name of the macro
  (kmacro-name-last-macro name)         ; use this name for the macro
  (find-file user-init-file)            ; open ~/.emacs or other user init file
  (goto-char (point-max))               ; go to the end of the .emacs
  (newline)                             ; insert a newline
  (insert-kbd-macro name)               ; copy the macro
  (newline)                             ; insert a newline
  (switch-to-buffer nil))               ; return to the initial buffer
;### End Macros ###


;### Package stuff ###
(package-initialize)

(setq jpk-packages
      '(
        ac-dabbrev
        ...
        yasnippet
        ))

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

; Install any packages in jpk-packages, if they are not installed already
(let ((refreshed nil))
  (when (not package-archive-contents)
    (package-refresh-contents)
    (setq refreshed t))
  (dolist (pkg jpk-packages)
    (when (and (not (package-installed-p pkg))
             (assoc pkg package-archive-contents))
      (unless refreshed
        (package-refresh-contents)
        (setq refreshed t))
      (package-install pkg))))

(setq installed-packages '(matlab-mode
                           ;ido-ubiquitous
                           workgroups2
                           elpy
                           yasnippet
                           sr-speedbar
                           yafolding
                           clang-format
                           ))
(mapc #'package-install installed-packages)

(elpy-enable)

;(with-eval-after-load 'python
;  (defun python-shell-completion-native-try ()
;    "Return non-nil if can trigger native completion."
;    (let ((python-shell-completion-native-enable t)
;          (python-shell-completion-native-output-timeout
;           python-shell-completion-native-try-output-timeout))
;      (python-shell-completion-native-get-completions
;       (get-buffer-process (current-buffer))
;       nil "_"))))

;### End package stuff ###

;(require 'sublimity)
;(require 'sublimity-scroll)
;(require 'sublimity-map)
;(require 'workgroups2)
;(require 'misc-cmds)

(global-set-key (kbd "<C-tab>") 'next-buffer)
(global-set-key (kbd "<C-S-tab>") 'previous-buffer)

(defun scroll-down-in-place (n)
  (interactive "p")
  (previous-line n)
  (unless (eq (window-start) (point-min))
    (scroll-down n)))

(defun scroll-up-in-place (n)
  (interactive "p")
  (next-line n)
  (unless (eq (window-end) (point-max))
    (scroll-up n)))

(global-set-key "\M-n" 'scroll-up-in-place)
(global-set-key "\M-p" 'scroll-down-in-place)

;(require 'yafolding)
(add-hook 'prog-mode-hook
          (lambda () (yafolding-mode)))

(defvar yafolding-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "<C-S-return>") #'yafolding-hide-parent-element)
    (define-key map (kbd "<C-M-return>") #'yafolding-toggle-all)
    (define-key map (kbd "<C-return>") #'yafolding-toggle-element)
    map))

(setq python-shell-completion-native-enable nil)
;(matlab-cedet-setup)
(yas-global-mode 1)
;(define-key yas-minor-mode-map (kbd "<tab>") nil)
;(define-key yas-minor-mode-map (kbd "TAB") nil)
;(define-key yas-minor-mode-map (kbd "<tab>") 'yas-expand)
;(workgroups-mode 1)

(global-set-key (kbd "C-x m") 'sr-speedbar-toggle)
(setq sr-speedbar-right-side nil)
;(sr-speedbar-open)

; Treat .h files like c++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(defun clang-format-buffer-on-save ()
  "Add auto-save hook for clang-format-buffer-smart."
  (add-hook 'before-save-hook 'clang-format-buffer nil t))

(fset 'c-indent-region 'clang-format-region) 

(add-hook 'c++-mode-hook 'clang-format-buffer-on-save)

; Open all selected files while in dired mode
(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map "F" 'my-dired-find-file)
     (defun my-dired-find-file (&optional arg)
       "Open each of the marked files, or the file under the point, or when prefix arg, the next N files "
       (interactive "P")
       (let* ((fn-list (dired-get-marked-files nil arg)))
         (mapc 'find-file fn-list)))))

; Reload all buffers frmo disk
(defun revert-all-buffers ()
  "Refresh all open file buffers without confirmation.
Buffers in modified (not yet saved) state in emacs will not be reverted. They
will be reverted though if they were modified outside emacs.
Buffers visiting files which do not exist any more or are no longer readable
will be killed."
  (interactive)
  (dolist (buf (buffer-list))
    (let ((filename (buffer-file-name buf)))
      ;; Revert only buffers containing files, which are not modified;
      ;; do not try to revert non-file buffers like *Messages*.
      (when (and filename
                 (not (buffer-modified-p buf)))
        (if (file-readable-p filename)
            ;; If the file exists and is readable, revert the buffer.
            (with-current-buffer buf
              (revert-buffer :ignore-auto :noconfirm :preserve-modes))
          ;; Otherwise, kill the buffer.
          (let (kill-buffer-query-functions) ; No query done when killing buffer
            (kill-buffer buf)
            (message "Killed non-existing/unreadable file buffer: %s" filename))))))
  (message "Finished reverting buffers containing unmodified files."))
