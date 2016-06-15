#!/bin/sh

emacs -batch -l ~/.emacs.d/init.el -eval '(org-publish "test-new-structure" t)'
