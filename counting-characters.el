(defconst prompt-text "What is the input string? ")
(defconst output-format-string "%s has %d characters")

(defun cc--emptyp (text)
  (= 0 (length text)))

(defun count-characters ()
  (interactive)
  (let ((text ""))
    (while (cc--emptyp text)
      (setq text (read-string prompt-text))
      (if (cc--emptyp text)
          (progn
            (message "Enter some text")
            (sit-for 1))
        (insert (format output-format-string text (length text)))))))

(provide 'counting-characters)
