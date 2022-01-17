;;; flycheck-sml.el --- Flycheck support for Standard ML -*- lexical-binding: t; -*-

;; Copyright (C) 2022 Dominic Martinez <dom@dominicm.dev>
;; Author: Dominic Martinez <dom@dominic.dev>
;; Created: 16 Jan 2022
;; Homepage: https://gitlab.com/dominicm00/flycheck-sml
;; Version: 0.0.1
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

;;; Code:

(require 'flycheck)

(flycheck-define-checker sml-smlnj
  "A Standard ML checker using the SML/NJ compiler.

See URL `http://www.smlnj.org/`"
  :command ("sml")
  :standard-input t
  :error-patterns
  ((warning line-start
            (optional "- ") (optional "= ") "stdIn:"
            line "." column (optional "-" end-line "." end-column)
            " Warning: " (message)
            line-end)
   
   ;; Match type errors
   (error line-start
          (optional "- ") (optional "= ") "stdIn:"
          line "." column (optional "-" end-line "." end-column)
          " Error: " (message)
          line-end)

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
