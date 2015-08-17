(require 'web-completion-data)

(defvar ac-html--tags-list nil "The list of tags.")
(defvar ac-html--global-attributes nil "The list of global attrs.")
(defvar ac-html--cached-attributes-alist nil)

(defun ac-html--load-list-from-file (filepath)
  "Return a list separated by \\n from FILEPATH."
  (with-current-buffer (find-file-noselect filepath)
    (unwind-protect
        (split-string
         (save-restriction
           (widen)
           (buffer-substring-no-properties (point-min) (point-max)))
         "\n" t)
      (kill-buffer))))

(defun ac-html--read-file (file-in-source-dir)
  "Return string content of FILE-IN-SOURCE-DIR from `web-completion-data-sources'."
  (let ((file (cdr (nth 0 (ac-html--all-files-named file-in-source-dir)))))
    ;; Just read from the first file.
    (when file
      (with-temp-buffer
        (insert-file-contents file)
        (buffer-string)))))

(defun ac-html--tags ()
  (if ac-html--tags-list
      ac-html--tags-list
    (setq ac-html--tags-list
          (ac-html--load-list-from-file
           (f-expand "html-tag-list" web-completion-data-html-source-dir)))
    ac-html--tags-list))

(defun ac-html--attributes-for-tag (tag)
  (unless ac-html--global-attributes
    (setq ac-html--global-attributes
          (ac-html--load-list-from-file
           (f-expand "html-attributes-list/global"
                     web-completion-data-html-source-dir))))
  (let (list attr-file)
    (setq attr-file (f-expand (format "html-attributes-list/%s" tag)
                              web-completion-data-html-source-dir))
    (if (file-exists-p attr-file)
        (setq list (ac-html--load-list-from-file
                    attr-file)))
    (append list ac-html--global-attributes)))

(defun ac-html--attrv-for-tag-and-attr (tag attr)
  )

(ac-html-define-data-provider "ac-html-default-data-provider"
  :tag-func 'ac-html-default-tags
  :attr-func 'ac-html-default-attrs
  :attrv-func 'ac-html-default-attrvs
  :id-func 'ac-html-default-ids
  :class-func 'ac-html-default-classes
  :tag-doc-func 'ac-html-default-tag-doc
  :attr-doc-func 'ac-html-default-attr-doc
  :attrv-doc-func 'ac-html-default-attrv-doc
  :id-doc-func 'ac-html-default-id-doc
  :class-doc-func 'ac-html-default-class-doc)

(provide 'ac-html-default-data-provider)
;;; ac-html-default-data-provider.el ends here
