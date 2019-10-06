
(defconst ccs--buffer-key 'ccs--buffer)
(defconst ccs--beginning-key 'ccs--beginning)
(defconst ccs--end-key 'ccs--end)

(defun ccs--save-buffer (buffer)
  (function-put 'cc--minibuffer-setup-hook ccs--buffer-key buffer))

(defun ccs--load-buffer ()
  (function-get 'cc--minibuffer-setup-hook ccs--buffer-key))

(defun ccs--save-beginning (beginning)
  (function-put 'cc--minibuffer-setup-hook ccs--beginning-key beginning))

(defun ccs--save-end (end)
  (function-put 'cc--minibuffer-setup-hook ccs--end-key end))

(defun ccs--clear-end ()
  (ccs--save-end nil))

(defun ccs--load-region ()
  (list
   (function-get 'cc--minibuffer-setup-hook ccs--beginning-key)
   (function-get 'cc--minibuffer-setup-hook ccs--end-key)))

(defun ccs--clear ()  
  (function-put 'cc--minibuffer-setup-hook ccs--buffer-key nil)
  (function-put 'cc--minibuffer-setup-hook ccs--beginning-key nil)
  (function-put 'cc--minibuffer-setup-hook ccs--end-key nil))

(provide 'counting-characters-storage)
