(defconst prompt-text "What is the input string? ")
(defconst output-format-string "%s has %d characters")

(defun cc--emptyp (text)
  (= 0 (length text)))

(defun count-characters ()
  (interactive)
  (let ((minibuffer-message-timeout 1)
        (text ""))
    (while (cc--emptyp text)
      (setq text (read-string prompt-text))
      (if (cc--emptyp text)
          (message "Enter some text")
        (insert (format output-format-string text (length text)))))))

(provide 'counting-characters)
