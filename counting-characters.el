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

(defun count-characters ()
  (interactive)
  (let ((text ""))
    (while (cc--emptyp text)
      (setq text (read-string prompt-text))
      (if (cc--emptyp text)
          (cc--send-message-and-wait "Enter some text")
        (insert (format output-format-string text (length text)))))))

(provide 'counting-characters)
