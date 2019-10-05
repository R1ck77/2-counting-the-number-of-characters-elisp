(require 'buttercup)
(setq load-path (cons "." load-path))
(require 'counting-characters)

(defconst some-text "Input by user")

(describe "count-characters"
  (it "prompts for a string using the correct text"
    (spy-on 'read-string)
    (with-temp-buffer
      (count-characters))
    (expect 'read-string
            :to-have-been-called-with "What is the input string? "))
  (it "writes the correct length for the input in the current buffer"
    (let ((result)
          (prev-text "PREVIOUS TEXT"))
      (with-temp-buffer
        (insert prev-text)
        (spy-on 'read-string :and-return-value some-text)
        (count-characters)
        (setq result (buffer-substring-no-properties (point-min) (point-max))))
      (expect result
              :to-equal (format "%s%s has %d characters" prev-text some-text (length prev-text))))))
