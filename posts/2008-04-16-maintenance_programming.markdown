---
title: Maintenance programming
tags: bash, programming
---

``` bash
$ history|awk '{a[$2]++} END{for(i in a){printf "%5d\t%s \n",a[i],i}}'|sort -rn|head
  215   cd
  121   ls
   97   vim
   41   grep
    4   find
    3   vimdiff
    3   touch
    2   tail
    2   perl
    2   less
```

