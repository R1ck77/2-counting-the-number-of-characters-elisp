(defconst prompt-text "What is the input string? ")
(defconst output-format-string "%s has %d characters")

(defun count-characters ()
  (interactive)
  (let ((text (read-string prompt-text)))
    (insert (format output-format-string text (length text)))))

(provide 'counting-characters)
