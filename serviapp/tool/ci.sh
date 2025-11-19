#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "▶️ Formatting Dart sources"
dart format lib test

echo "🔍 Running analyzer"
flutter analyze

echo "🧪 Running tests"
flutter test

echo "✅ CI checks completed"
