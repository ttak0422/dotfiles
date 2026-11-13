#!/bin/sh
# Probe only a newly generated disposable domain, never real application settings.
set -eu

if [ "$(uname -s)" != Darwin ] || [ "$(id -u)" = 0 ]; then
  echo "Run this test as a normal user on macOS." >&2
  exit 2
fi

suffix=$(/usr/bin/uuidgen)
case "$suffix" in
  ''|*[!A-Fa-f0-9-]*) echo "Invalid test-domain suffix." >&2; exit 2 ;;
esac
domain="org.dotfiles.defaults-test.$suffix"
# No domain argument or override is accepted. Refuse an existing domain.
if /usr/bin/defaults read "$domain" >/dev/null 2>&1; then
  echo "Refusing to touch existing domain: $domain" >&2
  exit 2
fi

temporary=$(/usr/bin/mktemp -d "${TMPDIR:-/tmp}/dotfiles-defaults.XXXXXX")
owned=0
cleanup() {
  result=$?
  trap - EXIT HUP INT TERM
  if [ "$owned" = 1 ]; then
    if ! /usr/bin/defaults delete "$domain"; then
      echo "Could not remove disposable domain: $domain" >&2
      result=1
    elif /usr/bin/defaults read "$domain" >/dev/null 2>&1; then
      echo "Disposable domain is still readable: $domain" >&2
      result=1
    fi
  fi
  # Remove only known files created by this test, not an arbitrary directory tree.
  rm -f "$temporary/before.plist" "$temporary/managed.plist"
  if ! rmdir "$temporary"; then
    echo "Inspect leftover test files: $temporary" >&2
    result=1
  fi
  exit "$result"
}
trap cleanup EXIT
trap 'exit 130' HUP INT TERM

printf 'Disposable domain: %s\nTemporary files: %s\n' "$domain" "$temporary"
owned=1
/usr/bin/defaults write "$domain" Sentinel -string keep
/usr/bin/defaults write "$domain" Managed -string before
/usr/bin/defaults export "$domain" "$temporary/before.plist"
cat > "$temporary/managed.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Managed</key><string>after</string>
  <key>Added</key><string>new</string>
</dict></plist>
PLIST
/usr/bin/plutil -lint "$temporary/managed.plist"
/usr/bin/defaults import "$domain" "$temporary/managed.plist"

status=0
if [ "$(/usr/bin/defaults read "$domain" Managed)" != after ] ||
   [ "$(/usr/bin/defaults read "$domain" Added 2>/dev/null || :)" != new ]; then
  echo "FAIL: managed values were not applied."
  status=1
fi
if [ "$(/usr/bin/defaults read "$domain" Sentinel 2>/dev/null || :)" = keep ]; then
  echo "PASS: import preserved the undeclared sentinel."
else
  echo "FAIL: import removed/changed the undeclared sentinel. Do not activate the profile."
  status=1
fi

# Test recovery regardless of the preservation result.
/usr/bin/defaults import "$domain" "$temporary/before.plist"
if [ "$(/usr/bin/defaults read "$domain" Sentinel 2>/dev/null || :)" = keep ] &&
   [ "$(/usr/bin/defaults read "$domain" Managed 2>/dev/null || :)" = before ] &&
   ! /usr/bin/defaults read "$domain" Added >/dev/null 2>&1; then
  echo "PASS: snapshot import restored both original keys and removed the added key."
else
  echo "FAIL: snapshot import was not an exact restoration. Do not activate the profile."
  status=1
fi
exit "$status"
