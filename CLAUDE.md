# CLAUDE.md — Belsam Academy LMS

Operating guide for Claude Code in this repository. **Read this fully at the start of every session and follow it.** When anything here conflicts with a habit or a default, this file wins.

---

## 1. What this project is

The **Belsam Academy** mobile app — a Learning Management System (LMS) built in **Flutter** for **Android and iOS** (a web target also exists). It is based on the **Rocket LMS / "Webinar"** commercial template; the internal Dart package name is **`webinar`**, so imports look like `package:webinar/...`.

Because this is a customized third-party codebase, the prime directive is:

> **Fix and improve without breaking working functionality.** Stability beats cleverness. Prefer the smallest change that correctly solves the problem. If a change feels risky or you're unsure it's safe, STOP and ask before proceeding.

---

## 2. Environment & versions (verified — do not drift)

- **Flutter:** project was scaffolded on **stable 3.29.2** (Dart 3.7), but `pubspec.lock` was last resolved requiring **Dart `>=3.8.0-0` / Flutter `>=3.27.0`** (i.e. a Flutter ~3.32 toolchain).
- **`pubspec.yaml` declares:** Dart SDK `>=3.4.0 <4.0.0`.
- **Action:** At the start of a session, run `flutter --version` and work with the toolchain that's actually installed. Use the latest installed **stable 3.x**.
- **Do NOT** run `flutter upgrade`, change the channel, edit the `environment:` SDK constraints in `pubspec.yaml`, or bump dependency versions unless the task explicitly requires it — and if it does, call it out first.
- Use **`flutter pub get`** (respects the lockfile). Do **not** run `flutter pub upgrade` / `--major-versions` casually.

---

## 3. Commands (the canonical set)

```bash
flutter pub get                                         # install deps (after any pubspec change)
dart format .                                           # auto-format
flutter analyze                                         # static analysis / lints  <- HARD GATE
flutter test                                            # run tests (see §8 caveat)
flutter gen-l10n                                        # regenerate localizations after editing .arb files
dart run build_runner build --delete-conflicting-outputs # regenerate Hive (*.g.dart) after model changes

# Run / build
flutter run                                             # run on a connected device/emulator
flutter run -d <deviceId>                               # target a specific device
flutter build apk --release                             # Android APK
flutter build appbundle --release                       # Android App Bundle (Play Store)
flutter build ios --release                             # iOS (requires macOS + Xcode)
flutter clean                                           # nuke build artifacts when builds act strangely
```

If a build behaves oddly after dependency or generated-code changes, the reliable reset is:
`flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs`.

---

## 4. Architecture map (where things live)

Entry point and routing:
- **`lib/main.dart`** — app entry; **declares all named routes** and initializes Firebase, Hive, timezone, splash, and providers. Treat it carefully: it's central wiring. (It's listed as an `unmanaged_file` in `.metadata`.)
- **`lib/locator.dart`** — `get_it` **service locator**. Registers `Dio`, `AppLanguage`, `CurrencyUtils`, and the app's providers as singletons. Resolve via `locator<T>()`; register new singletons here following the existing pattern.
- **`lib/common/common.dart`** — barrel of shared helpers: the global `navigatorKey`, `loading()`, `space()`, `nextRoute()`. Reuse these instead of reinventing navigation/spacing/loading widgets.

`lib/app/` — feature code:
- **`pages/`** — screens grouped by feature: `authentication_page/`, `introduction_page/`, `offline_page/`, and `main_page/` (containing `home_page/` [the largest area: courses, quizzes, assignments, cart, meetings, certificates, forum, support, settings, etc.], `blog_page/`, `categories_page/`, `classes_page/`, `providers_page/`).
- **`providers/`** — Provider/`ChangeNotifier` state: `app_language_provider`, `drawer_provider`, `filter_course_provider`, `home_provider`, `page_provider`, `providers_provider`, `theme_provider`, `user_provider`.
- **`services/`** — API/business layer over **Dio**: `authentication_service/`, `guest_service/`, `user_service/`. Network calls belong here, not in widgets.
- **`models/`** — data models / DTOs.
- **`widgets/`** — reusable widgets, grouped by feature.

`lib/common/` — shared infrastructure:
- **`database/model/`** — **Hive** persistence, e.g. `course_model_db.dart` (`@HiveType(typeId: 1)`) + generated `course_model_db.g.dart`. New Hive types need a unique `typeId` and a `build_runner` regen.
- **`enums/`** — `course_enum`, `error_enum`, `meeting_type_enum`, `page_name_enum`.
- **`utils/`** — `app_text.dart`, `constants.dart`, `currency_utils.dart`.
- **`data/`** — e.g. `app_language.dart`.

`lib/config/` — configuration:
- **`l10n/`** — localization (see §6).
- **`theme/`** — `light_colors.dart`, `dark_colors.dart`; plus `colors.dart`, `styles.dart`, `assets.dart`, `notification.dart`.

**Before editing, read the neighbouring files in the target folder and mirror their conventions.** Do not impose a new structure or pattern.

---

## 5. Code conventions

- **State management:** `provider` only. Follow existing `ChangeNotifier` + `Consumer`/`context.watch`/`context.read` usage. Do **not** add Bloc, Riverpod, GetX, or MobX.
- **DI:** `get_it` via `locator`. Don't instantiate services ad-hoc if a singleton exists.
- **Networking:** reuse the shared `Dio` instance and the `services/` layer. Don't create parallel HTTP clients.
- **Persistence:** `hive`/`hive_flutter` for structured local data, `shared_preferences` for simple key/values — match what the surrounding code already uses.
- **Imports:** use `package:webinar/...` for cross-feature imports, consistent with the codebase.
- **Lints:** `flutter_lints` (config in `analysis_options.yaml`, default rule set). Keep code analyzer-clean. Don't silence lints with broad `// ignore_for_file:` unless clearly justified.
- **Formatting:** always `dart format .` before committing.
- Keep diffs minimal and focused; preserve existing public widget/method signatures unless the task is specifically to change them.

---

## 6. Localization & RTL (English + Arabic)

- The app ships **English (`app_en.arb`) and Arabic (`app_ar.arb`)** and supports **right-to-left (RTL)** layouts. Config: `l10n.yaml` (`arb-dir: lib/config/l10n`, template `app_en.arb`, output `app_localizations.dart`).
- **No hardcoded user-facing strings.** Add a key to **both** `app_en.arb` and `app_ar.arb`, then reference it through the generated `AppLocalizations`. Follow existing key naming.
- The generated localization files (`app_localizations*.dart`) **are committed to `lib/config/l10n/`**. After editing `.arb` files, run **`flutter gen-l10n`** and commit the regenerated output. Don't hand-edit the generated `.dart` files.
- **Test new UI in Arabic/RTL**: check alignment, padding/margins (use directional insets where appropriate), and any icons/chevrons that should mirror. Use the bundled fonts (Vazir for Arabic, SF-Pro otherwise) as existing screens do.

---

## 7. Cross-platform requirements (Android + iOS must both keep working)

Verified native config:
- **Android:** `applicationId`/`namespace` `com.webinar.webinar`, `minSdk 21`, `targetSdk 35`, `compileSdk 35`, AGP `8.7.0`, Kotlin `1.8.22`, Gradle in **Kotlin DSL** (`android/app/build.gradle.kts`). Permissions in `android/app/src/main/AndroidManifest.xml`.
- **iOS:** deployment target **15.6** (`ios/Podfile`), bundle id `com.webinar.webinar`. Permissions/usage strings in `ios/Runner/Info.plist`. CocoaPods-based; iOS builds require macOS + Xcode.

Rules:
- **Never write code that silently breaks one platform.** Where behaviour must differ, branch explicitly with `Platform.isIOS` / `Platform.isAndroid` or `defaultTargetPlatform`.
- **Permissions live in two files** — update **both** `AndroidManifest.xml` and `Info.plist` when adding a capability. iOS requires a usage-description string or the app crashes/gets rejected.
- Many plugins here need per-platform native setup (`permission_handler`, `image_picker`, `file_picker`, `firebase_messaging`, `flutter_local_notifications`, `google_sign_in`, `flutter_facebook_auth`, `webview_flutter`/`flutter_inappwebview`, the video players, `syncfusion_flutter_pdfviewer`). When touching these, verify native config on both platforms.
- Respect minSdk 21 and iOS 15.6 — don't use APIs that require higher without raising it deliberately and noting it.
- **When working on Windows you can't build/run iOS.** Say so explicitly and flag any iOS-side implications (Info.plist entries, Podfile, capabilities, signing) for verification on a Mac.

---

## 8. Quality gates (run before EVERY commit)

```bash
dart format .
flutter analyze      # must be clean — no new errors/warnings
flutter test         # must not introduce new failures
```

Regenerate first if relevant:
- Edited `.arb` -> `flutter gen-l10n`
- Changed a Hive model / anything code-generated -> `dart run build_runner build --delete-conflicting-outputs`

**Hard rule: do not commit if `flutter analyze` reports new problems.** Leave the analyzer at least as clean as you found it.

> **Test caveat:** the repo currently contains only the default `test/widget_test.dart`, which likely does **not** match this app and may fail as-is. Treat **`flutter analyze` as the primary gate**. When you fix a bug or add logic, prefer adding/repairing a focused test for it rather than assuming the suite is green. Do not delete tests just to make a run pass.

---

## 9. Git workflow (protects the original code)

- **NEVER commit directly to `main`.** `main` is the source of truth and must always stay in a known-good, working state.
- **Every change goes on its own branch**, created from an up-to-date `main`:
  - `fix/<short-desc>` — bug fixes (e.g. `fix/video-player-crash`)
  - `feat/<short-desc>` — features / improvements
  - `chore/<short-desc>` — deps, config, cleanup
- **Commit messages:** Conventional Commits — `fix:`, `feat:`, `chore:`, `refactor:`, `docs:`. Imperative subject <= ~72 chars, short body when the change isn't obvious.
- **One logical change per commit.** Show me the diff summary before committing.
- **Never force-push; never rewrite shared history.** Respect branch protection.
- **Pushing a branch is safe and encouraged. Merging into `main` is MY decision.** Do not merge to `main` or merge PRs yourself unless I explicitly say so — open a Pull Request and let me review. If a fix turns out bad, the branch is simply deleted and `main` is untouched.

---

## 10. Don't-break guardrails

- **No broad refactors while fixing a bug.** Fix the bug; propose larger refactors separately.
- **No dependency changes** in `pubspec.yaml` unless required — and if required, flag it, run `flutter pub get`, and confirm the app still builds on both platforms.
- **Never hand-edit generated files** (`*.g.dart`, `app_localizations*.dart`). Change the source and regenerate.
- **Never touch secrets/credentials or release config:** `google-services.json`, `ios/Runner/GoogleService-Info.plist`, Firebase setup, signing keys/keystores, provisioning profiles, or any API keys. Don't print their contents.
- **Don't delete or weaken existing tests** to force a green run — fix the root cause.
- **Don't change app identity** (`applicationId`/bundle id `com.webinar.webinar`, app name, versioning) unless explicitly asked.
- Preserve existing behaviour and public signatures unless the task is to change them.

---

## 11. How to work (apply to any non-trivial task)

1. **Reconnaissance (read-only).** Explore the relevant files; understand how the feature currently works and exactly what's broken. Don't edit yet.
2. **Plan.** State plainly what you'll change, which files, why, and the risks. Wait for confirmation on anything large or ambiguous.
3. **Implement.** Smallest correct change, matching existing patterns. Then run the §8 gates.
4. **Wrap up.** Commit on a correctly named branch with a Conventional Commit message, push, and open a PR for review.

Work on **one problem per branch** — don't bundle unrelated fixes.

---

## 12. Definition of Done

A task is complete only when **all** of these hold:
1. The specific problem is actually fixed, and you've explained how you verified it.
2. `dart format`, `flutter analyze` (clean), and `flutter test` (no new failures) all pass.
3. Generated code is up to date (`gen-l10n` / `build_runner`) if sources changed.
4. New user-facing text exists in both `app_en.arb` and `app_ar.arb` and works in RTL.
5. Android and iOS implications are handled or explicitly flagged.
6. Work is on a properly named branch, committed with a Conventional Commit, pushed, and a PR is open — **`main` is untouched.**
