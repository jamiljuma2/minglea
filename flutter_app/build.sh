#!/bin/bash
set -e

# Download Flutter SDK
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.6-stable.tar.xz
# Extract Flutter SDK
 tar xf flutter_linux_3.19.6-stable.tar.xz
# Add Flutter to PATH
export PATH="$PATH:$(pwd)/flutter/bin"
# Check Flutter installation
flutter doctor
# Get dependencies
flutter pub get
# Build web output
flutter build web
