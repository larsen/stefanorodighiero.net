./site clean
./site build
rsync -vac _site/* larsen@home:/srv/www/stefanorodighiero.net/
