;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Bevis Halsey-Perry"
      user-mail-address "hi@be7.is")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' ('non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 20)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 14))

(setq projectile-project-search-path '("~/Projects/"))
(setq projectile-auto-discover 'nil)

(set-popup-rules!
  '(("^\\*doom:vterm-popup" :height 0.15)
    ("^\\*doom:eshell-popup" :height 0.15)))


;; ORG STUFF

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Org/")

(after! org
  (add-to-list 'org-modules 'org-habit))

(setq
    org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿")
    )

(setq org-blank-before-new-entry
      '((heading . t) (plain-list-item . nil)))

(setq org-refile-targets
      '((nil :maxlevel . 5)
        (org-agenda-files :maxlevel . 5)))


(map! :map evil-org-mode-map
      :after evil-org
      :localleader
      :nv "i" nil
      :nv "e" nil
      :nv "f" nil
      :nv "h" nil
      :nv "I" nil
      :nv "n" nil
      :nv "q" nil
      :nv "o" nil
      :nv "x" nil
      :nv "T" nil
      :nv "t" nil
      (:prefix "i" ;insert
       :nv "h" #'org-insert-heading
       :nv "H" #'org-insert-heading-after-current
       :nv "s" #'org-insert-subheading
       :nv "i" #'org-insert-item
       :nv "d" #'org-insert-drawer
       :nv "e" #'org-set-effort
       :nv "f" #'org-footnote-new
       :nv "t" #'org-set-tags-command
       :nv "c" #'org-ref-helm-insert-cite-link
       :nv "p" #'org-set-property)
      (:prefix "T" ;toggles
       :nv "i" #'org-toggle-item
       :nv "I" #'org-toggle-inline-images
       :nv "h" #'org-toggle-heading
       :nv "c" #'org-toggle-checkbox)
      :nv "t" #'org-todo
      )

(map! :leader
      (:prefix-map ("n" . "notes")
       (:prefix ("b" . "bibliography")
        :desc "Note for entry" "n" #'org-ref-open-bibtex-notes
        :desc "Add bibliography entry from url" "l" #'org-ref-url-html-to-bibtex
        :desc "Open bibliography file" "f" #'(lambda () (interactive) (find-file "~/Org/Resources/Bibliography/references.bib"))
        :desc "Biblio" "b" #'biblio-lookup
        )
       :desc "Start Org-Noter" "r" #'org-noter)
      )

(map! :leader
      (:prefix-map ("i" . "insert")
       :desc "Insert BibTex entry" "b" #'org-ref-bibtex-new-entry/body))


(setq org-log-into-drawer t)

;; Org Agenda Stuff
(setq org-agenda-files (directory-files-recursively "~/Org/" "\\.org$")) ;; must be before adding other things to agenda file list
;;(setq org-agenda-files (directory-files-recursively "~/Projects/" "\\.org$")) ;; must be before adding other things to agenda file list



;; Org Capture Stuff
(after! org

(defvar my/org-contacts-template
"* %(org-contacts-template-name) :%^{Relationship|_acquaintance|_organisation|_colleague|_friend|_family}:
:PROPERTIES:
:Address: %^{Address in the format '5 Thermite Lane, Boomtown, Explodaland, BO15 4CD, UK'}
:Mobile: %^{Number in the format '(+00)0000 000 000'}
:Email: %^{Email} :Kind: %^{Kind of contact entry|Individual|Group|Organisation|Geographic}
:Note: %^{Note}
:Birthday: %^{Birthday in the format 'YYYY-MM-DD'}
:END:"
"Template for org-contacts.")

(defvar my/org-webclip-template
"* %^{Title} :_web_clip:%^G:
:PROPERTIES:
:Source: [[%:link][%:description]]
:Accessed: %u
:END:
#+BEGIN_QUOTE
%i
#+END_QUOTE
\n\n\n%?"
"Template for web clip.")

(defvar my/org-bookmark-template
"* [[%:link][%:description]] :_webpage:%^G:
:PROPERTIES:
:Accessed: %u
:END:
%?"
"Template for bookmarks.")

(defvar my/org-tag-topics-template
"* %^{PROMPT} :%\\1:
#+TAGS: [ %\\1 :]
%?"
"Template for tag category topics.")

        (setq org-capture-templates `(
                ("b" "Web Clip" entry (file "~/Org/Inbox/Inbox.org"),
                 my/org-webclip-template
                 :empty-lines 1)
                ("l" "Bookmark Link" entry (file "~/Org/Inbox/Inbox.org"),
                 my/org-bookmark-template
                 :empty-lines 1)
                ("c" "Contact" entry (file "~/Org/Personal/Contacts.org"),
                 my/org-contacts-template
                 :empty-lines 1)
                ("t" "Tag Topic" entry (file+headline "~/Org/Meta/Tags.org" "Topic"),
                 my/org-tag-topics-template
                 :empty-lines 1)
                )))

;; Org Contacts Stuff
(use-package org-contacts
  :ensure nil
  :after org
  :custom (org-contacts-files '("~/Org/Personal/Contacts.org")))
(setq org-agenda-include-diary t)

;; Org Babel stoooof
;; (with-eval-after-load 'jupyter
;; (org-babel-jupyter-override-src-block "python")
;; )

;; Org Projects stuff
(use-package! org-projectile
  :config
    (org-projectile-per-project)
    (map! :leader
      (:prefix "n"
        :desc "projectile-project-complete-read" "p" #'org-projectile-project-todo-completing-read)) ;Capture TODO for specific projects
    (defun org-projectile-get-project-todo-file (project-path)
      (message "Called")
      (message project-path)
      (concat "~/Projects/" (file-name-nondirectory (directory-file-name project-path)) "/"  "Proj_" (file-name-nondirectory (directory-file-name project-path)) ".org")))
(push (org-projectile-project-todo-entry) org-capture-templates)
(setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
;; Doesnt work
;;(defun be7/org-projectile-goto-project-file ()
;;  "Open the project .org file for the current project."
;;  (interactive)
;;  (org-projectile-goto-location-for-project (projectile-project-name)))
;;(map! :leader
;;      (:prefix "p"
;;       :desc "projectile-goto-project-file" "n" #'be7/org-projectile-goto-project-file))
;; Org journal stiff
;;
(setq org-journal-dir "~/Org/Journal/")
(setq org-journal-file-type 'weekly)


(use-package! org-collector)

;; Org link stuff
(setq org-link-abbrev-alist
      `(
        ("contact" . ,(concat org-directory "Personal/Contacts.org::*%s"))
        ))

;; Org Export stuff
(with-eval-after-load 'ox-latex
(add-to-list 'org-latex-classes
             '("org-plain-latex"
               "\\documentclass{article}
           [NO-DEFAULT-PACKAGES]
           [PACKAGES]
           [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))
(setq org-latex-listings 't)

(setq org-latex-listings 'minted)
(setq org-latex-minted-options
      '(("frame" "lines") ("linenos=true")))

;;(use-package! pdf-tools
;;  :config
;;  (pdf-tools-install))


;; Org ref and bibtex thangs
(use-package! org-ref
        :after org

        :init
        (let ((cache-dir (concat doom-cache-dir "org-ref")))
        (unless (file-exists-p cache-dir)
        (make-directory cache-dir t))
        (setq orhc-bibtex-cache-file (concat cache-dir "/orhc-bibtex-cache")))
        (setq bibtex-dialect 'biblatex)
        (setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))

        :config
        (setq
                org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
                org-ref-pdf-directory "~/Org/Resources/Bibliography/Ref_Docs/"
                org-ref-default-bibliography '("~/Org/Resources/Bibliography/references.bib")
                org-ref-bibliography-notes "~/Org/Resources/Bibliography/references.org"
                org-ref-note-title-format "* %t (%y)\n :PROPERTIES:\n :Custom_ID: %k\n :AUTHOR: %9a\n :JOURNAL: %j\n :YEAR: %y\n :VOLUME: %v\n :PAGES: %p\n :DOI: %D\n :URL: %U\n :END:\n\n"
                org-ref-notes-directory "~/Org/Resources/Bibliography/"
                org-ref-notes-function #'org-ref-notes-function-one-file)

        (defun get-pdf-filename (key)
          (let ((results (bibtex-completion-find-pdf key)))
            (if (equal 0 (length results))
                (org-ref-get-pdf-filename key)
              (car results))))

        (add-hook 'org-ref-create-notes-hook
                (lambda ()
                (org-entry-put
                nil
                "NOTER_DOCUMENT"
                (get-pdf-filename (org-entry-get
                                        (point) "Custom_ID")))) )
        )

(after! org-ref
        (setq
        bibtex-completion-notes-path "~/Org/Resources/Bibliography/references.org"
        bibtex-completion-bibliography "~/Org/Resources/Bibliography/references.bib"
        bibtex-completion-pdf-field "file"
        bibtex-completion-library-path "~/Org/Resources/Bibliography/Ref_Docs/"
        )
)

(use-package! org-noter
  :after org
  :config
  (setq org-noter-always-create-frame nil
        org-noter-notes-window-location 'vertical-split
        org-noter-doc-split-fraction '(0.25 . 0.75)
        org-noter-notes-search-path '("~/Org")
        org-noter-auto-save-last-location t
        org-noter-default-notes-file-names '("~/Org/Resources/Bibliography/references.org"))
  )

(setq reftex-default-bibliography '("~/Org/Resources/Bibliography/references.bib"))

(setq biblio-download-directory "~/Org/Resources/Bibliography/Ref_Docs/")

(setq bibtex-completion-pdf-open-function 'org-open-file)

(after! org
  (require 'org-ref))



;; Org Agenda Stuff
;;(use-package! org-super-agenda
;;  :after org-agenda
;;  :init
;;  (setq org-agenda-skip-scheduled-if-done t
;;      org-agenda-skip-deadline-if-done t
;;      org-agenda-include-deadlines t
;;      org-agenda-block-separator nil
;;      org-agenda-compact-blocks t
;;      org-agenda-start-day nil ;; i.e. today
;;      org-agenda-start-on-weekday nil)
;;  (setq org-agenda-custom-commands
;;        '(("c" "Super day view"
;;           ((agenda "" ((org-agenda-span 'day)
;;                        (org-super-agenda-groups
;;                         '((:name "Today"
;;                                  :time-grid t
;;                                  :date today
;;                                  :order 1)))))
;;            (alltodo "" ((org-agenda-overriding-header "")
;;                         (org-super-agenda-groups
;;                          '((:log t)
;;                            (:name "To refile"
;;                                   :file-path "inbox.org")
;;                            (:name "Next to do"
;;                                   :todo "NEXT"
;;                                   :order 1)
;;                            (:name "Important"
;;                                   :priority "A"
;;                                   :order 6)
;;                            (:name "Today's tasks"
;;                                   :file-path "journal/")
;;                            (:name "Due Today"
;;                                   :deadline today
;;                                   :order 2)
;;                            (:name "Scheduled Soon"
;;                                   :scheduled future
;;                                   :order 8)
;;                            (:name "Overdue"
;;                                   :deadline past
;;                                   :order 7)
;;                            (:name "Meetings"
;;                                   :and (:todo "MEET" :scheduled future)
;;                                   :order 10)
;;                            (:discard (:not (:todo "TODO")))))))))))
;;  :config
;;  (org-super-agenda-mode))

;;
;; UK public holidays, and other UK notable dates.
(setq calendar-holidays
      '((holiday-fixed 1 1 "New Year's Day")
        (holiday-new-year-bank-holiday)
        (holiday-fixed 2 14 "Valentine's Day")
        (holiday-fixed 3 17 "St. Patrick's Day")
        (holiday-fixed 4 1 "April Fools' Day")
        (holiday-easter-etc -47 "Shrove Tuesday")
        (holiday-easter-etc -21 "Mother's Day")
        (holiday-easter-etc -2 "Good Friday")
        (holiday-easter-etc 0 "Easter Sunday")
        (holiday-easter-etc 1 "Easter Monday")
        (holiday-float 5 1 1 "Early May Bank Holiday")
        (holiday-float 5 1 -1 "Spring Bank Holiday")
        (holiday-float 6 0 3 "Father's Day")
        (holiday-float 8 1 -1 "Summer Bank Holiday")
        (holiday-fixed 10 31 "Halloween")
        (holiday-fixed 12 24 "Christmas Eve")
        (holiday-fixed 12 25 "Christmas Day")
        (holiday-fixed 12 26 "Boxing Day")
        (holiday-christmas-bank-holidays)
        (holiday-fixed 12 31 "New Year's Eve")))
;; N.B. It is assumed that 1 January is defined with holiday-fixed -
;; this function only returns any extra bank holiday that is allocated
;; (if any) to compensate for New Year's Day falling on a weekend.
;;
;; Where 1 January falls on a weekend, the following Monday is a bank
;; holiday.
(defun holiday-new-year-bank-holiday ()
  (let ((m displayed-month)
        (y displayed-year))
    (calendar-increment-month m y 1)
    (when (<= m 3)
      (let ((d (calendar-day-of-week (list 1 1 y))))
        (cond ((= d 6)
                (list (list (list 1 3 y)
                            "New Year's Day Bank Holiday")))
              ((= d 0)
                (list (list (list 1 2 y)
                            "New Year's Day Bank Holiday"))))))))
;; N.B. It is assumed that 25th and 26th are defined with holiday-fixed -
;; this function only returns any extra bank holiday(s) that are
;; allocated (if any) to compensate for Christmas Day and/or Boxing Day
;; falling on a weekend.
(defun holiday-christmas-bank-holidays ()
  (let ((m displayed-month)
        (y displayed-year))
    (calendar-increment-month m y -1)
    (when (>= m 10)
      (let ((d (calendar-day-of-week (list 12 25 y))))
        (cond ((= d 5)
                (list (list (list 12 28 y)
                            "Boxing Day Bank Holiday")))
              ((= d 6)
                (list (list (list 12 27 y)
                            "Boxing Day Bank Holiday")
                      (list (list 12 28 y)
                            "Christmas Day Bank Holiday")))
              ((= d 0)
                (list (list (list 12 27 y)
                            "Christmas Day Bank Holiday"))))))))
