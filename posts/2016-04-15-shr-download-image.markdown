---
title: A useful addition to elfeed
tags: emacs, elisp, programming
---

_This post had a rather convoluted story. It started with a practical
problem to solve. Proceeding towards the solution I had to recur to
some more general programming techniques, and I kept writing about
them. Now I reached a point where the code seems acceptable, but the
need for those tecniques disappeared, as I found in Emacs API exactly
the functionality I was naively rewriting. I decided it would have
been more clear to split my notes into two separate articles: perhaps
this function I prepared has some dignity on its own. So, here the
first part. More coming._

* * * *

One relatively new entry in my emacs setup is
[elfeed](http://nullprogram.com/blog/2013/09/04/), a system to fetch
and display RSS feeds. In the past I've been a user of Google Reader
(which I had of course to abandon) and later of Feedly, but I felt
elfeed might fit better in my workflow.

One thing I want to do from time to time is to download pictures from
posts. After learning that elfeed uses
[Simple HTML Renderer](https://www.emacswiki.org/emacs/HtmlRendering)
to display posts, I wrote this function:

~~~~ {.commonlisp}
(require 'url)
(require 'f)  ;; for filename manipulations

(defun shr-download-image ()
  "Downloads the image under point"
  (interactive)
  (let ((url (get-text-property (point) 'image-url)))
    (if (not url)
        (message "No image under point!")
      (url-copy-file url (concat "~/Pictures/elfeed/"
                                 (f-filename
                                  (url-filename
                                   (url-generic-parse-url url))))))))
~~~~

A couple of things going on here that require an explanation:

* First of all, we need to capture the URL under the cursor. The entry
  buffer is a rendition of a data structure we need to peek into.
 
~~~~ {.commonlisp}
(let ((url (get-text-property (point) 'image-url))) ...
~~~~

* If we were able to actually capture some non-`nil` value, we want to
  retrieve the corresponding content (the image). I initially used
  `url-retrieve`, then I found the much more practical `url-copy-file`.
  
* Eventually, I bound this function to <kbd>D</kbd>

~~~~ {.commonlisp}
(define-key elfeed-show-mode-map "D" #'shr-download-image)
~~~~

### Edit

Thanks to machi suggestions in the comments, here a shorter, better
version of the function:

~~~~ {.commonlisp}
(defun shr-download-image ()
  "Downloads the image under point"
  (interactive)
  (let ((url (get-text-property (point) 'image-url)))
    (if (not url)
        (message "No image under point!")
      (url-copy-file url (expand-file-name (url-file-nondirectory url)
                                 "~/Pictures/elfeed/")))))
~~~~

* `url-file-nondirectory` is a simpler and more succinct than my
  composition of parse + `url-filename` + f-filenam
  
* `expand-file-name` is more expressive (and I think more robust) than
  `concat`
