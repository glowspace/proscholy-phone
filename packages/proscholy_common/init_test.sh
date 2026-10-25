#!/bin/zsh

# objectbox-dart has no tags for 6.0.0 previews, so the C library of objectbox 6.0.0-preview.5 is installed directly
bash <(curl -s https://raw.githubusercontent.com/objectbox/objectbox-c/v6.0.0-beta2/download.sh) --quiet 6.0.0-beta2

mv -f lib/libobjectbox.dylib /usr/local/lib/libobjectbox.dylib
rm -rf download
