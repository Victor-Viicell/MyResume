#!/usr/bin/env bash
# Regenerate the downloadable PDFs from the static pages.
set -euo pipefail

cd "$(dirname "$0")/.."

BROWSER="${BROWSER:-}"
if [ -z "$BROWSER" ]; then
  for candidate in chromium chromium-browser google-chrome-stable google-chrome; do
    if command -v "$candidate" >/dev/null 2>&1; then
      BROWSER="$candidate"
      break
    fi
  done
fi

if [ -z "$BROWSER" ]; then
  echo "Chrome or Chromium is required to generate the PDFs." >&2
  exit 1
fi

build_pdf() {
  local page="$1"
  local output="$2"
  local tmp
  tmp="$(mktemp --suffix=.pdf)"

  "$BROWSER" \
    --headless=new \
    --disable-gpu \
    --no-sandbox \
    --hide-scrollbars \
    --no-pdf-header-footer \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=3000 \
    --print-to-pdf="$tmp" \
    "file://$PWD/$page" >/dev/null 2>&1

  mv "$tmp" "$output"
  echo "Generated $output"
}

build_pdf "index.html" "Victor-Lucas-Gomes-da-Silva-Resume-EN.pdf"
build_pdf "pt-br.html" "Victor-Lucas-Gomes-da-Silva-Curriculo-PT-BR.pdf"
