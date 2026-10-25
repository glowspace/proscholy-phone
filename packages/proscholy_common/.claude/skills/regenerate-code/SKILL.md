---
name: regenerate-code
description: Regenerate freezed, json_serializable, riverpod and objectbox code in proscholy-common and commit it together with the change that caused it. Use after changing any file with a `part 'generated/...'` directive, a `@riverpod` provider or an ObjectBox entity.
---

# Regenerate code

1. Run `dart run build_runner build --delete-conflicting-outputs`.
2. Check `git status`. Only generated files that belong to the sources you changed should change.
   If unrelated generated files change too, a generator version moved (dev dependencies are `any`).
   Commit that churn on its own first, with a message naming the generator, so it does not hide the real change.
3. If `lib/models/generated/objectbox-model.json` changed, read its diff:
   - A new UID for an existing entity or property, or a UID that moved to `retiredEntityUids`/`retiredPropertyUids`,
     means its stored data is dropped when users update the app.
   - That is only acceptable for data that is re-downloaded from the API. Never for playlists, user texts or settings.
   - Renames must keep the UID with `@Entity(uid: ...)` / `@Property(uid: ...)`.
4. Run `flutter analyze` and the tests (see the `verify` skill).
5. Commit the generated files in the same commit as the handwritten change, so every commit works for the apps.
