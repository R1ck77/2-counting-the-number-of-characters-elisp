(require 'cl)
(require 'buttercup)
(setq load-path (cons "." load-path))
(require 'counting-characters)

(defconst some-text "Input by user")

(describe "count-characters"
  (it "prompts for a string using the correct text"
    (spy-on 'read-string :and-return-value "Something")
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
              :to-equal (format "%s%s has %d characters" prev-text some-text (length prev-text)))))
  (it "prompts the user to write something if nothins enters nothing"
    (lexical-let ((empty-calls 2)
                  (current-call 0))
      (spy-on 'read-string :and-call-fake (lambda (x)
                                            (setq current-call (+ 1 current-call))
                                            (if (<= current-call empty-calls)
                                                ""
                                              "Dave")))
      (spy-on 'message)
      (count-characters)
      (expect 'message :to-have-been-called-times 2))))
