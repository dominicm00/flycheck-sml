;;; flycheck-sml.el --- Flycheck support for Standard ML -*- lexical-binding: t; -*-

;; Copyright (C) 2022 Dominic Martinez <dom@dominicm.dev>
;; Author: Dominic Martinez <dom@dominic.dev>
;; Created: 16 Jan 2022
;; Homepage: https://gitlab.com/dominicm00/flycheck-sml
;; Version: 0.1.0
;; Package-Requires ((flycheck) (sml-mode))
;; Keywords: convenience, languages, tools

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; This package provides minimal Standard ML checking through SML/NJ.
;; No other Standard ML compilers are currently supported.

;;; WARNING
;; SML/NJ does not appear to be able to type check code snippets
;; without running them in the REPL.  This means that this checker
;; **will execute code exactly how it works in the REPL, including
;; side effects**.  Please only use this with caution on code that you
;; trust until a solution is found.

;;; Code:

(require 'flycheck)

(flycheck-define-checker sml-smlnj
  "A Standard ML checker using the SML/NJ compiler.

See URL `http://www.smlnj.org/`"
  :command ("sml")
  :standard-input t

  ;; These error patterns are a bit hacky due to how SML/NJ formats
  ;; errors. The end of a message is determined by either the start of
  ;; another error ("s" at start of line), a REPL prompt ("-" at start
  ;; of line), or the end of output ("\n" at start of line). We match
  ;; the message non-greedily on all characters until we reach one of
  ;; these end markers, and then make those characters optionally
  ;; match at the beginning of the error since they may have been
  ;; captured by the previous error.
  :error-patterns
  ((warning (optional "- ") (optional "= ") (optional "s") "tdIn:"
            line "." column (optional "-" end-line "." end-column)
            " Warning: " (message (+? anychar)) line-start (or "s" "-" "\n"))
   
   ;; Match type errors
   (error (optional "- ") (optional "= ") (optional "s") "tdIn:"
          line "." column (optional "-" end-line "." end-column)
          " Error: " (message (+? anychar)) line-start (or "s" "-" "\n"))

   ;; Match exceptions
   (error line-start
          "uncaught exception " (message)
          "\n  raised at: stdIn:"
          line "." column (optional "-" end-line "." end-column)
          line-end))
  :modes sml-mode)

(eval-after-load 'flycheck
  '(add-to-list 'flycheck-checkers 'sml-smlnj))

(provide 'flycheck-sml)

;;; flycheck-sml.el ends here
