(require 'cl)

(defconst prompt-text "What is the input string? ")
(defconst output-format-string "%s has %d characters")

(defconst cc--fallback-minibuffer-message-timeout 1
  "Timeout to wait for a message to disappear when no timeout is specified by the user")

(defun cc--emptyp (text)
  (= 0 (length text)))

(defun cc--get-minibuffer-message-timeout ()
    (let ((timeout minibuffer-message-timeout))
      (if (numberp timeout)
          timeout
        cc--fallback-minibuffer-message-timeout)))

(defun cc--send-message-and-wait (text)
  (message text)
  (sit-for (cc--get-minibuffer-message-timeout)))

(defun cc--remove-insertion-selection (insertion-beginning)
  (let ((old-insertion-end (function-get 'cc--minibuffer-setup-hook 'insertion-end)))
    (when old-insertion-end
      (delete-region insertion-beginning old-insertion-end)
      (function-put 'cc--minibuffer-setup-hook 'insertion-end nil))))

(defun cc--insert-text (insertion-start text)
  (cc--remove-insertion-selection insertion-start)
  (goto-char insertion-start)
  (insert (format output-format-string text (length text))))

(defun cc--after-change-function-generator (buffer insertion-beginning)
  (lexical-let ((buffer buffer)
                (insertion-beginning insertion-beginning))
    (lambda (beginning end prev-length)
      (let ((insertion-text (minibuffer-contents)))
        (with-current-buffer buffer
          (cc--insert-text insertion-beginning insertion-text)
          (function-put 'cc--minibuffer-setup-hook 'insertion-end (point)))))))

(defun cc--minibuffer-setup-hook ()
  (add-hook 'after-change-functions
            (cc--after-change-function-generator (function-get 'cc--minibuffer-setup-hook 'buffer)
                                                 (function-get 'cc--minibuffer-setup-hook 'insertion-beginning))
            nil t))

(defun cc--minibuffer-exit-hook ()
  (remove-hook 'after-change-functions t)
  (cc--remove-hooks))

(defun cc--clear-contextual-properties ()
  (function-put 'cc--minibuffer-setup-hook 'buffer nil)
  (function-put 'cc--minibuffer-setup-hook 'insertion-beginning nil)
  (function-put 'cc--minibuffer-setup-hook 'insertion-end nil))

(defun cc--add-hooks ()
  (function-put 'cc--minibuffer-setup-hook 'buffer (current-buffer))
  (function-put 'cc--minibuffer-setup-hook 'insertion-beginning (point))
  (add-hook 'minibuffer-setup-hook 'cc--minibuffer-setup-hook)
  (add-hook 'minibuffer-exit-hook 'cc--minibuffer-exit-hook))

(defun cc--remove-hooks ()
  (remove-hook 'minibuffer-setup-hook 'cc--minibuffer-setup-hook)
  (remove-hook 'minibuffer-exit-hook 'cc--minibuffer-exit-hook))

(defun cc--hooked-read-string ()
  (cc--add-hooks)
  (read-string prompt-text))

(defun count-characters ()
  (interactive)
  (cc--clear-contextual-properties)
  (let ((text "")
        (insertion-start (point)))
    (while (cc--emptyp text)
      (setq text (cc--hooked-read-string))
      (if (cc--emptyp text)
          (cc--send-message-and-wait "Enter some text")
        (cc--insert-text insertion-start text)))))

(provide 'counting-characters)
