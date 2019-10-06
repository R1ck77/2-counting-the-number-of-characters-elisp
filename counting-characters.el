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

(defun cc--after-change-function-generator (buffer)
  (lexical-let ((buffer buffer))
    (lambda (beginning end prev-length)
      (insert (buffer-substring-no-properties beginning end))
      (insert "\n"))))

(defun cc--minibuffer-setup-hook ()
  (add-hook 'after-change-functions
            (cc--after-change-function-generator (function-get 'cc--minibuffer-setup-hook 'buffer))
            nil t))

(defun cc--minibuffer-exit-hook ()
  (remove-hook 'after-change-functions t)
  (cc--remove-hooks))

(defun cc--add-hooks ()
  (function-put 'cc--minibuffer-setup-hook 'buffer (current-buffer))
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
  (let ((text ""))
    (while (cc--emptyp text)
      (setq text (cc--hooked-read-string))
      (if (cc--emptyp text)
          (cc--send-message-and-wait "Enter some text")
        (insert (format output-format-string text (length text)))))))

(provide 'counting-characters)
