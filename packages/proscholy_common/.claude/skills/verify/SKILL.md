---
name: verify
description: Check a change in proscholy-common before committing it, covering formatting, analyzer issues and tests for all three targets (ZPS, EZ, EK). Use before every commit and before reporting work as done.
---

# Verify a change

1. Format the handwritten files you touched: `dart format <files>`. Never format files in `generated/` folders.
2. Run `flutter analyze` and compare it with the run before your change. The change must not add any issue.
   To see only the issues in files you touched:
   `flutter analyze 2>&1 | grep -F -f <(git diff --name-only HEAD)`.
3. Run the tests for every target:

   ```bash
   for t in ZPS EZ EK; do flutter test --dart-define=ZPEVNIK_TARGET=$t || break; done
   ```

   If a test fails with "ObjectBox platform-specific database library not compatible", the native library must be
   updated with `./init_test.sh`. That downloads a library, so ask the user first.
4. If the UI changed, run the ZPS app (`../../apps/zps`, `--dart-define=ZPEVNIK_TARGET=ZPS`) in the iOS simulator
   and check the affected screens.
5. Report exactly what passed. If you skipped a step, say so.
