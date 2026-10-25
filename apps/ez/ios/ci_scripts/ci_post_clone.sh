#!/bin/sh

# The default execution directory of this script is the ci_scripts directory.
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

# Install Flutter using git.
git clone https://github.com/flutter/flutter.git -b 3.44.4 $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# Install Flutter dependencies.
flutter pub get

# Install CocoaPods using Homebrew.
brew install cocoapods

# Generate iOS configuration with the target of this app (Xcode compiles Dart with its defines), the Swift package of
# plugins and install CocoaPods dependencies.
flutter build ios --config-only --dart-define=ZPEVNIK_TARGET=EZ

exit 0