---
title: How fast my git repositories are growing?
---

I wrote a very small utility to gather LOC counts from a git repository. Called <a href="https://github.com/larsen/gitsloc">gitsloc</a>, it's based on <a href="http://cloc.sourceforge.net/">Cloc</a>, with some extra goodness provided by <a href="http://search.cpan.org/~mschilli/Sysadm-Install/">Sysadm::Install</a> (a rather inaptly named module, if you ask to me, but full of useful gems).

I guess it could actually have some uses, who knows?, but I wrote it mostly because I wanted to <strong>see</strong> how fast repos are growing, and <a href="http://www.r-project.org/">R</a> is the obvious tool to tinker with the results.

I'm less than a beginner with R, and I have to admit plotting data from a multi-column CSV file is less straitghforward than I expected: I had to use <code>xyplot</code> from the <a href="http://cran.r-project.org/web/packages/lattice/index.html">lattice package</a>, like this:

[gist id=1127531 bump=1]

Here the result, with data provided analysing the <a class="zem_slink" title="Dancer (software)" href="http://www.perldancer.org/" rel="homepage">Dancer</a> github repository (branch devel).
<div class="zemanta-pixie" style="margin-top: 10px; height: 15px;"><img class="aligncenter size-full wp-image-340" title="Rplot01" alt="" src="http://www.stefanorodighiero.net/blog/wp-content/uploads/2011/08/Rplot01.png" width="520" height="296" /><img class="zemanta-pixie-img" style="border: none; float: right;" alt="" src="http://img.zemanta.com/pixy.gif?x-id=2fd34d65-26e5-4457-a9e2-18ef531e2b67" /></div>
