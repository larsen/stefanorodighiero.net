---
title: Pocket Perl - Package e moduli
---

## Approfondimenti

[Lo scopo dello
scope](http://www.perl.it/documenti/articoli/namespaces/index.html),
versione in Italiano di [Coping with
scoping](http://perl.plover.com/FAQs/Namespaces.html), di [Mark-Jason
Dominus](http://perl.plover.com/)

## Errata corrige

**Pag. 107**

Nel testo si fa riferimento alla variabile ``@EXPORT_TAGS``. In
realtà il nome corretto è ``%EXPORT_TAGS`` (si tratta quindi di un hash,
non di un array). Il codice di esempio riportato diventa dunque:

````perl
%EXPORT_TAGS = ( 
  disney => [ qw{ pippo pluto paperino } ] 
);
````