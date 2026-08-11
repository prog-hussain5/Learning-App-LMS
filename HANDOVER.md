# Balsam Academy — Handover / Build Guide

This branch (`final-app`) contains the complete, current state of the app. It is the
branch to build from.

The app is a Flutter LMS (Android + iOS) based on the Rocket LMS / "Webinar" template.
The internal Dart package name is still `webinar`, so imports look like `package:webinar/...`.

**Access model:** students receive credentials out-of-band (Telegram). An admin assigns
courses to them. There is **no in-app purchase and no self-registration** — the app is
login-only (email + password).

---

## 1. Server

| | |
|---|---|
| Domain | `https://blsm.app` |
| API base | `https://blsm.app/api/development/` |
| API key header | `x-api-key: balsam2025key` |
| Defined in | `lib/common/utils/constants.dart` |

Everything derives from `Constants.dommain` (note the spelling — it is `dommain`, not
`domain`). Changing that one constant moves the whole app to another server.

Verified working: `GET /api/development/config` returns 200, and `POST /api/development/login`
returns a proper JSON validation error.

> **Important:** the backend rejects any request whose `Content-Type` is not exactly
> `application/json`. Dart's `http` appends `; charset=utf-8` if you set headers *before*
> the body, which breaks login. `lib/common/utils/http_handler.dart` deliberately sets the
> **body first, then headers**. Do not "clean this up" — see `test/http_content_type_test.dart`.

---

## 2. Toolchain

Built and verified with:

```
Flutter 3.41.7 (stable)
```

Use `flutter pub get` (respects `pubspec.lock`). Avoid `flutter pub upgrade`.

---

## 3. Building Android

```bash
flutter pub get
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

**Signing.** `android/app/build.gradle.kts` looks for `android/key.properties`:

```properties
storeFile=/absolute/path/to/keystore.jks
storePassword=...
keyAlias=...
keyPassword=...
```

If that file is **absent**, the build falls back to **debug signing** so the APK still
builds (useful for test builds/CI). For a Play Store release you must supply the real
keystore — a debug-signed APK cannot be published.

**NDK.** `ndkVersion = "29.0.13113456 rc1"`. Gradle installs it automatically provided the
Android SDK licences are accepted (`sdkmanager --licenses`).

App Bundle for Play Store:

```bash
flutter build appbundle --release
```

---

## 4. Building iOS  ⚠️ requires macOS + Xcode

**All Flutter/Dart work in this branch is platform-neutral and compiles for both platforms,
but the iOS side has never been compiled — the work was done on Windows.** The Swift code
below is the part that needs a real build and a device test.

```bash
flutter pub get
cd ios && pod install && cd ..
flutter build ios --release
```

| | |
|---|---|
| Deployment target | iOS 15.6 (`ios/Podfile`) |
| Bundle id | `com.balsamacademy.app` |
| Entitlements | `ios/Runner/RunnerDebug.entitlements` (aps-environment = development)<br>`ios/Runner/RunnerRelease.entitlements` (aps-environment = production) |

### Please verify on a device (highest priority)

1. **It compiles.** `ios/Runner/AppDelegate.swift` was written but never compiled.
2. **Screen protection** — see §5. Test screenshot + screen recording, and specifically
   **while a lecture video is playing** (native video/webview views are the one case that
   can escape the protection).
3. **Push notifications** — needs the APNs key uploaded in the Firebase console, the
   `aps-environment` entitlement (present), and `remote-notification` in UIBackgroundModes.

---

## 5. Screen-capture protection

| Threat | Android | iOS |
|---|---|---|
| Screenshot | blocked (`FLAG_SECURE`) | renders **black** |
| Screen recording | blocked | renders **black** + on-screen warning |
| AirPlay / mirroring | blocked | renders **black** |
| App-switcher preview | blocked | black cover |

- **Android:** `FLAG_SECURE` applied app-wide in `lib/main.dart`.
- **iOS:** iOS has **no API to prevent** screenshots. The strongest available approach is
  used instead — content is hosted inside a `secureTextEntry` field's redacted layer, so
  the OS renders it black in any system capture. Applied at the **window** level, so it
  covers every screen. See `ios/Runner/AppDelegate.swift` (`screen_guard` MethodChannel,
  started from `lib/common/utils/screen_guard_ios.dart`).

---

## 6. What changed (this engagement)

Roughly 24 commits on top of the previous state. Highlights:

**Reliability — "sometimes it doesn't load"**
- Central network layer (`lib/common/utils/http_handler.dart`): 30s timeout, **3× auto-retry
  on GETs**, debounced error snackbar, and a non-throwing synthetic error response so callers
  degrade gracefully instead of crashing. A stray 401 no longer force-logs-out mid-lecture.
- Content/quiz models made null-safe; lecture and quiz screens gained explicit **error +
  Retry** states instead of blank screens or infinite spinners.

**Quizzes**
- Tapping a quiz inside a course opened *My Results* instead of the quiz — fixed.
- A quiz with **no time limit** auto-submitted an empty sheet ~1s after opening — fixed
  (`test/quiz_time_limit_test.dart` covers it).
- The quizzes list showed one row **per attempt**; now shows one row per quiz (latest attempt).
- Grading, timer and model round-trip bugs fixed.

**Lectures / media**
- Video player: no error path meant a bad/expired URL span forever. Now fails to an error +
  Retry. Fixed a `setState`-after-dispose and a controller leak when leaving mid-load.
- Players are the **original design** (Chewie for uploads, `youtube_player_flutter` for
  YouTube), lightly polished: brand-green progress bars, a loading spinner, and a playback
  speed control. (A full custom-controls redesign was built and then deliberately reverted.)
- PDF viewer: added failure handling (was a permanently blank page).
- Attachments downloaded the **wrong file** (used the parent lesson id) — fixed.
- Downloads silently did nothing on Android 13+ (a needless storage-permission gate) — fixed.

**Auth / UI**
- Login failure against the server — the `Content-Type` issue described in §1.
- **Registration removed** (commented out, not deleted): the signup link, the route and the
  import. `register_page.dart` is untouched on disk — uncomment to restore.
- **Google/Facebook sign-in hidden** (commented out) — email + password only.
- Free-app disclaimer banner removed.
- Home screen: shows the student's **own courses** as full-width cards, plus "Suggested for
  you" and "Free courses" discovery rows. Fixed a collapsing app-bar that clipped the
  greeting while scrolling.

**Performance**
- Removed a dead 500ms delay on every course-page open; splash 3s → 800ms; images now decode
  at display size.

**Notifications** — Android tap-routing plus the iOS entitlements/APNs wiring.

---

## 7. Backend

Some fixes are **server-side** (Rocket LMS / Laravel) and are **not in this repo**. They were
delivered as a folder named `cluadeupdate` inside the Rocket LMS source, containing the edited
PHP files with their original paths preserved, plus a README. Ask Hussein for it.

They cover: memoised purchase checks (`checkUserHasBought`), null-guards in the content and
quiz endpoints, and sales indexes.

---

## 8. Quality gates

```bash
dart format .
flutter analyze     # currently: 0 errors, 0 warnings
flutter test
```

`flutter test` — the meaningful tests pass. **`test/widget_test.dart` fails and always has**:
it is the stock Flutter counter template from the initial commit and does not match this app.
It is unrelated to any change here; delete or rewrite it when convenient.

After editing `.arb` files run `flutter gen-l10n`. After changing Hive models run
`dart run build_runner build --delete-conflicting-outputs`.

---

## 9. Known open items

1. **iOS has never been compiled** — highest priority (§4).
2. **A non-PDF upload that isn't marked "downloadable" shows no View/Download button** —
   the student can't open it. Button logic gap in `single_content_page.dart`.
3. **The PDF viewer sends no auth headers**, so privately stored ("secure host") PDFs return
   403 with no recovery. Harmless if your PDFs are public.
4. **A video reporting a 0 aspect ratio** can throw instead of failing gracefully.

Items 2–4 were found by audit, judged low severity, and intentionally left unfixed.

---

## 10. Localisation

English + Arabic, with RTL. Strings live in `lib/config/l10n/app_en.arb` and `app_ar.arb`;
the generated Dart is committed. **No hardcoded user-facing strings** — add a key to *both*
files and run `flutter gen-l10n`.

Watch out: `newestClasses` is translated in Arabic as **"كورساتي" ("My Courses")** — the
template key was repurposed. Don't reuse it for a "newest" section; it will read as a second
"My Courses".
