# ghci-pager
Show values in ghci through a pager

Install using «make install». 

This makes available a ghci command `:setless` which redefines the
interactive print function to `Less.less`, which in turn will use the
value of `$PAGER` to show results of interactive evaluations.

Note:
Because the `Less` module is not part of a package, the `:set
-interactive-print=Less.less` it will not survive `cd, add, load,
reload, set`. Use `:setless` to reenable it.

