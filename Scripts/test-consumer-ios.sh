#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
consumer=$(mktemp -d "${TMPDIR:-/tmp}/mangotools-consumer.XXXXXX")
trap 'rm -rf "$consumer"' EXIT
cp -R "$root/Tests/VersionConsumer/." "$consumer/"
cd "$consumer"

# The release job never sets MANGOTOOLS_LOCAL_PATH. It must resolve the remote
# exact semver tag, in a new package directory with no checkout/cache reuse.
if [[ -z "${MANGOTOOLS_LOCAL_PATH:-}" ]]; then
  export MANGOTOOLS_VERSION="${MANGOTOOLS_VERSION:-0.1.0}"
  [[ "$MANGOTOOLS_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Invalid release version" >&2; exit 1; }
fi
swift package resolve
if [[ -z "${MANGOTOOLS_LOCAL_PATH:-}" ]]; then
  python3 - <<'PY'
import json, os, pathlib, subprocess
version = os.environ['MANGOTOOLS_VERSION']
resolved = json.loads(pathlib.Path('Package.resolved').read_text())
pins = resolved.get('pins', resolved.get('object', {}).get('pins', []))
match = [pin for pin in pins if pin.get('identity', pin.get('package', '')).lower() == 'mangotools']
assert len(match) == 1, pins
state = match[0]['state']
assert state['version'] == version, state
refs = subprocess.check_output(['git', 'ls-remote', 'https://github.com/100mango/MangoTools.git', f'refs/tags/v{version}', f'refs/tags/v{version}^{{}}'], text=True).splitlines()
assert refs, 'Release tag missing'
sha = refs[-1].split()[0]
assert state['revision'] == sha, (state, refs)
print(f'Resolved remote version {version} at exact tag commit {sha}')
PY
fi

if [[ -z "${SIMULATOR_ID:-}" ]]; then
  SIMULATOR_ID=$(xcrun simctl list devices available --json | python3 -c '
import json, sys
for runtime, devices in sorted(json.load(sys.stdin)["devices"].items(), reverse=True):
    if ".iOS-" not in runtime or int(runtime.split(".iOS-", 1)[1].split("-", 1)[0]) < 15:
        continue
    for device in devices:
        if device.get("isAvailable") and "iPhone" in device["name"]:
            print(device["udid"])
            sys.exit(0)
sys.exit("No available iPhone simulator running iOS 15+.")
')
fi
xcodebuild -scheme MangoToolsConsumer-Package \
  -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" \
  -destination-timeout 180 -parallel-testing-enabled NO \
  -derivedDataPath "$consumer/.build/xcode" \
  CODE_SIGNING_ALLOWED=NO IPHONEOS_DEPLOYMENT_TARGET=15.0 test
