# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

The repository is a pub workspace with three songbook apps and their shared code:

| Folder | Content |
| --- | --- |
| `packages/proscholy_common` | nearly all code of the apps, see its [CLAUDE.md](packages/proscholy_common/CLAUDE.md) |
| `apps/zps` | Zpěvník ProScholy (target `ZPS`) |
| `apps/ez` | Evangelický zpěvník (target `EZ`) |
| `apps/ek` | Evangelický kancionál (target `EK`) |

`flutter pub get` anywhere in the repository resolves the whole workspace into one `pubspec.lock` in the root. Apps use
`proscholy_common` from the workspace, so a change of it reaches all three apps in the same commit.

Run an app from its folder, e.g. `cd apps/zps && flutter run --dart-define=ZPEVNIK_TARGET=ZPS`. Android releases are
built with `build_android.sh` of the app, iOS builds run in Xcode Cloud with `ios/ci_scripts/ci_post_clone.sh` of the app.
