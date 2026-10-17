#!/bin/zsh

flutter pub get

VERSION=$(cat pubspec.lock | grep -E objectbox$ -A 4 | grep version | awk -F'"' '{print $2}')
echo $VERSION

bash <(curl -s https://raw.githubusercontent.com/objectbox/objectbox-dart/v$VERSION/install.sh)

rm lib/libobjectbox.dylib
rm -rf download
