# flycheck-sml

A [flycheck](https://github.com/flycheck/flycheck) checker for SML
based on SML/NJ. Creates a `sml-smlnj` checker that activates
automatically in
[sml-mode](https://www.smlnj.org/doc/Emacs/sml-mode.html).

## WARNING
SML/NJ does not appear to be able to type check code snippets without
running them in the REPL. This means that this checker **will execute
code exactly how it works in the REPL, including side
effects**. Please only use this with caution on code that you trust
until a solution is found.

## Installation

[SML/NJ](http://www.smlnj.org/) is required for this checker.

Include `flycheck-sml.el` in your `init.el`. flycheck-sml is currently
not available through MELPA or the official flycheck repo and must be
installed manually.
