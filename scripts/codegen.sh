#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# MoneyFlow — Isar code generation script
#
# Usage:
#   ./scripts/codegen.sh [feature]
#
# Examples:
#   ./scripts/codegen.sh          # rebuild ALL Isar schemas
#   ./scripts/codegen.sh categories
#   ./scripts/codegen.sh transactions
#
# Why this script exists:
#   isar_generator 3.x pins analyzer ^5.0.0 and is fundamentally incompatible
#   with bloc_test ^10.x on Dart ^3.11.0-200.1.beta (flutter_test pins
#   test_api 0.7.8 via the SDK).
#   This script temporarily swaps dev_dependencies so both tools can exist in
#   the project without a permanent conflict.
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

PUBSPEC="pubspec.yaml"
BACKUP="pubspec.yaml.dev.bak"

cleanup() {
  if [[ -f "$BACKUP" ]]; then
    echo "Restoring original pubspec.yaml..."
    cp "$BACKUP" "$PUBSPEC"
    rm "$BACKUP"
    flutter pub get --quiet
    echo "Restored."
  fi
}

# Always restore on exit (including errors / Ctrl-C)
trap cleanup EXIT

echo "▶ Backing up pubspec.yaml..."
cp "$PUBSPEC" "$BACKUP"

echo "▶ Swapping dev_dependencies for code generation..."
# Remove bloc_test and mocktail; add isar_generator
flutter pub remove --dev bloc_test mocktail 2>/dev/null || true
flutter pub add --dev isar_generator:^3.1.0+1

echo "▶ Running build_runner..."
if [[ -n "${1:-}" ]]; then
  # Build only the specific feature path
  flutter pub run build_runner build \
    --build-filter="lib/features/${1}/**" \
    --delete-conflicting-outputs
else
  # Build all
  flutter pub run build_runner build --delete-conflicting-outputs
fi

echo "✓ Code generation complete."
# cleanup() runs automatically via trap
