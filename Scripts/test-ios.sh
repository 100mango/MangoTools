#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "Full Xcode with an iOS Simulator runtime is required." >&2
  exit 1
fi

swift package dump-package >/dev/null
swift package describe

# Check that public headers do not depend on a consumer's prefix header.
sdk=$(xcrun --sdk iphonesimulator --show-sdk-path)
architecture=$(uname -m)
for header in \
  " NSString+Tools/NSString+Tools.h" \
  "NSDate+Utilities/NSDate+Utilities.h" \
  "NSAttributedString+Attributes/NSAttributedString+Attributes.h" \
  "UIView+Tools/UILabel+Tools.h" \
  "UIView+Tools/UIView+Tools.h" \
  "UIView+Tools/UIView+AnimationExtensions.h" \
  "MangoLog/MangoLog.h" \
  "Macro/MangoMacro.h" \
  "EXTScope/EXTScope.h" \
  "SwiftPMHeaders/MangoToolsObjC.h"; do
  xcrun --sdk iphonesimulator clang \
    -target "${architecture}-apple-ios9.0-simulator" \
    -isysroot "$sdk" -fmodules -fblocks -fobjc-arc -fsyntax-only \
    -x objective-c "$header"
done

# Select an installed iPhone instead of hard-coding a model or OS version.
if [[ -z "${SIMULATOR_ID:-}" ]]; then
  SIMULATOR_ID=$(xcrun simctl list devices available --json | python3 -c '
import json, sys
for runtime, devices in sorted(json.load(sys.stdin)["devices"].items(), reverse=True):
    if ".iOS-" not in runtime:
        continue
    if int(runtime.split(".iOS-", 1)[1].split("-", 1)[0]) < 15:
        continue
    for device in devices:
        if device.get("isAvailable") and "iPhone" in device["name"]:
            print(device["udid"])
            sys.exit(0)
sys.exit("No available iPhone simulator running iOS 15+. Install an iOS runtime in Xcode.")
')
fi

# Keep the test harness deployment separate from the library's iOS 9 floor.
# Swift 5.5 originally introduced actor annotations alongside iOS 15.
xcodebuild \
  -scheme MangoTools-Package \
  -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" \
  -destination-timeout 180 \
  -parallel-testing-enabled NO \
  -derivedDataPath .build/xcode \
  CODE_SIGNING_ALLOWED=NO \
  IPHONEOS_DEPLOYMENT_TARGET=15.0 \
  test
