#!/usr/bin/env bash
# Verify the CSV -> report demo: golden output matches, bad input fails without writing.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# 1) Happy path: output matches the golden file byte-for-byte.
python3 -I "$here/report.py" "$here/input.csv" "$tmp/report.md"
diff -u "$here/expected.md" "$tmp/report.md"

# 2) Existing artifact is never overwritten.
if python3 -I "$here/report.py" "$here/input.csv" "$tmp/report.md" 2>/dev/null; then
  echo "FAIL: overwrote existing artifact" >&2; exit 1
fi

# 3) Invalid amount fails and writes nothing.
printf 'category,amount_usd\nCompute,abc\n' > "$tmp/bad.csv"
if python3 -I "$here/report.py" "$tmp/bad.csv" "$tmp/bad.md" 2>/dev/null; then
  echo "FAIL: accepted invalid amount" >&2; exit 1
fi
[ ! -e "$tmp/bad.md" ] || { echo "FAIL: wrote output for invalid input" >&2; exit 1; }

echo "csv-report demo: PASS"
