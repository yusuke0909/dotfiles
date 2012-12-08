#!/bin/bash
#
# lesspipe.sh - my less pipe script for Mac OS X
#
# Usage:
#  export LESSOPEN="|/path/to/lesspipe.sh  %s"
#
case `file "$1"` in
    *Mach-O*)
        lipo -i "$1"
        otool -L "$1"
        otool -tV "$1"
        ;;
esac
case "$1" in
    *.a|*.dylib)
        nm "$1"
        ;;
    *.Z) uncompress -c "$1"
        ;;
    *.tar) tar tvf "$1"
        ;;
    *.tar.gz) tar ztvf "$1"
        ;;
    *.tar.bz2) tar jtvf "$1"
        ;;
    *.zip) unzip -l "$1"
        ;;
    *.jar) jar tvf "$1"
        ;;
    *.dmg) hdiutil imageinfo "$1"
        ;;
    *.ps|*.pdf) mdls "$1"
        ;;
    *.jpg|*.png|*.gif|*.bmp|*.tiff) mdls "$1"
        ;;
    *.mp3|*.mp4|*.mpg|*.avi|*.mov|*.mkv) mdls "$1"
        ;;
esac
