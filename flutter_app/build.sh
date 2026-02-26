
#!/usr/bin/env bash
set -e

# Download Flutter SDK (3.41.2) if not already present
if [ ! -d "flutter" ]; then
	curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.41.2-stable.tar.xz
	tar xf flutter_linux_3.41.2-stable.tar.xz
fi
export PATH="$PATH:$(pwd)/flutter/bin"

# Show Flutter version
flutter --version

# Get dependencies
flutter pub get

# Build web with environment variable
flutter build web --dart-define=API_BASE_URL=https://minglea.onrender.com
