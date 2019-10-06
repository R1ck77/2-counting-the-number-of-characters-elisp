(require 'cl)
(require 'buttercup)
(setq load-path (cons "." load-path))
(require 'counting-characters-storage)

(describe "counting-characers-storage.el"
  (before-each
    (setplist 'cc--minibuffer-setup-hook '()))
  (describe "buffer save/load"
    (it "has no buffer set until we set one"
      (expect (ccs--load-buffer) :to-be nil))
    (it "sets/gets the property correctly"
      (ccs--save-buffer (current-buffer))
      (expect (ccs--load-buffer) :to-be (current-buffer)))
    (it "set gets correctly overwritten"
      (ccs--save-buffer (current-buffer))
      (ccs--save-buffer 12)
      (expect (ccs--load-buffer) :to-be 12))
    (it "is cleared by ccs--clear"
      (ccs--save-buffer (current-buffer))
      (ccs--clear)
      (expect (ccs--load-buffer) :to-be nil)))
  (describe "save-beginning/end"
    (it "save the correct values"
      (ccs--save-beginning 12)
      (ccs--save-end 44)
      (expect (ccs--load-region) :to-equal '(12 44)))
    (it "are cleared by ccs--clear"
      (ccs--save-beginning 12)
      (ccs--save-end 44)
      (ccs--clear)
      (expect (ccs--load-region) :to-equal '(nil nil)))))
