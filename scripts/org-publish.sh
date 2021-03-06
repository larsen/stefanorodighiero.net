#!/bin/bash

PROJECT_NAME="website"

function publish_pages {
    echo "Publishing pages..."
    emacs -batch -l ~/.emacs.d/init.el \
          -eval "(org-publish \"$PROJECT_NAME\")"
}

function publish_images {
    echo "Publishing images..."
    emacs -batch -l ~/.emacs.d/init.el \
          -eval "(org-publish \"${PROJECT_NAME}-images\")"
}

ALL=0
IMAGES=0
PAGES=1

while [[ $# -gt 0 ]]
do
    key="$1"
    case "$key" in
        -p|--pages)
            PAGES=1
            shift
            ;;
        -i|--images)
            IMAGES=1
            shift
            ;;
        -a|--all)
            ALL=1
            shift
            ;;
        -f|--force)
            rm ~/.org-timestamps/$PROJECT_NAME.cache
            shift
            ;;
        *)
            echo "Unknown option $1"
            exit
    esac
    
done

if [[ ($ALL = 1) || ($PAGES = 1) ]]; then
    publish_pages
fi
if [[ ($ALL = 1) || ($IMAGES = 1) ]]; then
    publish_images
fi

echo "Done."

