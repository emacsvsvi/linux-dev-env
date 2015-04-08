;;; This file contains small pieces of list code to test PmWiki mode

;; Open sandbox to play in.
;; Things to test:
;; * Add text and save, C-c C-c.
;; * Follow a link to an existing page, C-c C-f
;;	- Test both local link (e.g. HomePage) and full links
;;	  e.g. Main/HomePage and Main.HomePage
;; * Create new link and follow it

;; Code that loads pmwiki-mode from directory above.
(load-file "../http-get.el")
(load-file "../http-post.el")
(load-file "../pmwiki-mode.el")

;; Test opening a page via an explicit URI
(pmwiki-open "http://wiki.lyx.org/Devel/NSISNotes")
(pmwiki-open "http://pmwiki-mode.sourceforge.net/wiki/Bugs/Bug003")
(pmwiki-open "http://wiki.lyx.org/Test/Edit13FromPmwiki-mode")

;; Test opening a page from PmWiki
(pmwiki-open "Test/Edit13FromPmwiki-mode")
(pmwiki-open "Pm wiki / initial setup tasks")

;; Test going to an anchor
(pmwiki-open "http://wiki.lyx.org/pmwiki.php/FAQ/Unsorted#lyxHomeContents")

;;; Bug fixes:

;; Opening a page called 'Test.Höjdare' fails with a redirection.
(pmwiki-open "http://pmwiki.org/wiki/Test/Höjdare")
(pmwiki-link-to-loc "http://pmwiki.org/wiki/Test/Höjdare")
(pmwiki-http-url-encode "Höjdare" 'iso-8859-1)
(pmwiki-http-url-encode "Höjdare" 'utf-8)

;; Different redirection troubles for loading and saving
(pmwiki-open "http://wiki.lyx.org/Playground/TestPmwiki-mode")
(pmwiki-link-to-loc "/Playground/TestPmwiki-mode")

;; Default open fails to reload.
(pmwiki-open "")
(debugger-eval-expression pmwiki-reload)

(pmwiki-open "http://wiki.lyx.org/Test/Test")
(pmwiki-open "Devel/Tmp")
(pmwiki-open "http://www.algosyn.rwth-aachen.de/wiki/Main/HomePage")
(pmwiki-open "http://www.algosyn.rwth-aachen.de/wiki/index.php?n=Main.HomePage")
(setq pmwiki-always-edit nil)