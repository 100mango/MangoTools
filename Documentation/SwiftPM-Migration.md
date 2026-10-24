# Swift Package Manager migration

## Supported subset

This package uses Swift tools 5.5 or later, Swift 5 language mode, and declares iOS 9 or
later. UIKit and the Objective-C runtime are required. The manifest can be
inspected on Linux, but the library and tests require Xcode's iOS SDK and an iOS
Simulator. macOS, watchOS, tvOS, and Linux are not advertised as supported.

The original checkout had no deployment-target or package declaration. Its
exported APIs predate iOS 9; font descriptors and motion effects, for example,
were introduced in iOS 7. There is no source requirement for an iOS 12 floor.
iOS 9 is a conservative lower compatibility declaration for the Swift 5.5/Xcode
13 generation, not an old-device runtime test claim. Older deployment targets
require a toolchain that still supports them. The new manifest does not modify
manual source consumers' deployment settings.

Swift tools 5.5 is sufficient for this manifest and supports the test suite's
`@MainActor` annotations; the library does not use Swift concurrency. The test
class is separately available on iOS 15+, and the simulator script overrides the
test build's deployment target to iOS 15. That override is not written into the
library's manifest. Testing on a recent simulator does not verify iOS 9 runtime
behavior. See Apple's [Xcode 13 release notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-13-release-notes)
for that toolchain's iOS 9 device support and original concurrency availability,
and SwiftPM's [platform documentation](https://docs.swift.org/latest/documentation/packagedescription/supportedplatform/)
for deployment-target declarations.

Two separate source modules avoid mixing Swift and Objective-C in a Swift 5.5
target:

- `MangoTools` exports the Swift UIView geometry and typed table/collection cell
  registration and dequeue helpers. The responder-chain helper remains internal.
- `MangoToolsObjC` exports NSString, NSDate, attributed-string, UIView, UILabel,
  animation, MangoLog, MangoMacro, and EXTScope utilities.

The `MangoTools` library product includes both modules. Import `MangoTools` for
Swift helpers, and explicitly import `MangoToolsObjC` when using the Objective-C
utilities. The `MangoToolsObjC` product can also be used independently. Existing
source paths remain in place; do not compile copied versions of these files into
an app that also links the package, because that would duplicate definitions.
No podspec or existing project configuration was present or altered.

Modern UIKit spellings replace removed Swift 2 APIs. Existing convenience names
and unlabeled first arguments are retained, including the `NSIndexPath` argument
of `dequeueReusableCellForIndexPath`. Bridge with `indexPath as NSIndexPath` from
modern Swift. No new serialization format or third-party dependency is introduced.

The Objective-C edits address build blockers: a missing method-declaration
semicolon, missing UIKit/QuartzCore imports that previously relied on a prefix
header, and two references to the undeclared `bold` identifier in `addItalic:`.
The latter now uses that method's `italic` argument and has a regression test.

## Intentionally not exported

### `Swift/StructCoding.swift`

The original file remains unchanged for historical/manual consumers, but it is
explicitly excluded from the SwiftPM target. It is not safe to modernize this
file by mechanically replacing old compiler API spellings:

- Its default encoder copies a value's in-memory bytes, which can contain padding
  and references to String, Array, class instances, and other managed storage.
  Copying those bytes is not value serialization and does not retain the objects.
- Its decoder trusts arbitrary input, has no byte-length or type validation, and
  treats raw bytes as initialized Swift values. That can produce invalid values,
  dangling references, or memory-management failures.
- It confuses allocation element counts with byte sizes and does not deallocate.
- The protocol requires `decode(data:) -> Self`, while the default implementation
  returns an unconstrained associated type, `structType`.
- Memory layout is not a stable cross-version or cross-architecture file format.

There is no general memory-safe, wire-compatible replacement for this API for all
Swift structs. Choosing a replacement requires knowing the concrete conforming
types and whether existing data must be read. The reasonable next options are:

1. Introduce an explicit `Codable`-based API with throwing operations and a chosen,
   versioned format. This changes source requirements and stored bytes. Migration
   of old files needs per-type knowledge and validation.
2. For a documented fixed binary format, write an explicit per-field codec with
   length/range validation, endianness, and error handling. Do not reinterpret
   arbitrary memory or assume structs with references are plain byte values.

Existing saved raw-memory blobs must not be claimed to migrate automatically.
The package does not offer a misleading safe-looking version of `StructCoding`.

### `HudTools.h` / `HudTools.m`

These files remain unchanged and outside the package. They import an unvendored
`SVProgressHUD.h` and call the historical `showWithStatus:maskType:` API. Adding the
latest dependency without adapting and validating behavior would not resolve this
reliably. A follow-on migration must choose and review the dependency version,
replace the obsolete presentation configuration deliberately, and test dismissal
and timing. No dependency or extra HUD product is added here.

The README's JZLocationConverter reference is a link to another repository; there
are no converter sources in this checkout to export.

## Validation

Run from the repository root with full Xcode installed:

```sh
Scripts/test-ios.sh
```

The script checks the manifest, compiles each exported Objective-C header on its
own without a prefix header, selects an installed iPhone simulator running iOS 15 or newer, and runs the
package's XCTest suite without code signing. `SIMULATOR_ID` may specify an already
installed device. It does not install runtimes, sign/upload an app, or publish a
release. `.github/workflows/swift-package.yml` runs the same script on a standard
`macos-15` runner with read-only repository permissions and a 15-minute timeout.

Tests cover Swift geometry, responder traversal, reuse identifiers and typed
registration/dequeue; Objective-C strings, relative dates, italic/bold changes,
view borders/gestures/animations, labels, and EXTScope cleanup. They are focused
regression tests, not a claim to audit every existing utility's semantics or
thread safety. MangoLog's file-writing behavior is not exercised by this suite.

On a non-Apple host only `swift package dump-package`, `swift package describe`,
and Swift syntax parsing can be checked. Passing those checks is not an iOS
compile or test pass. Keep the migration in review until Apple SDK validation
passes. The excluded APIs remain follow-on work even after that pass.

## Licensing

No repository-wide license file was present in the baseline. Individual source
attributions, including EXTScope's MIT notice and animation helpers' CC0 notice,
remain intact. This migration does not choose or grant a new license. Confirm the
licensing of the aggregate library and third-party files before publishing a
release intended for redistribution.
