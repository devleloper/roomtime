# Integration regression list

Live-stack suites (no mocks). Start the stack (`make up ENV_FILE=...`), then run from `client/`:

```
flutter test integration_test/flows/<file> -d <device> --dart-define-from-file=config/local.json
```

Finders use the app's localizations (`l10nOf(tester)` in `support/live_app.dart`), so the suite runs on
simulators set to English or Russian.

| Flow | Test file | Platforms | Last result | Date |
| --- | --- | --- | --- | --- |
| Create room, look up by code, lobby (open room, host of password room, guest of password room, unknown code) | `flows/create_lookup_lobby_test.dart` | iOS Simulator (iPhone 18 Pro, iOS 27.2, ru) | 4/4 tests passed at least once; no single clean run: run 1 3/4 (not-found finder, since fixed), run 2 3/4 and run 3 0/1 (`POST /v1/rooms` 429 `rate_limited` after 12 rooms from one IP). Android not run | 2026-11-04 |

Manual device scenarios (iOS + Android + web, LiveKit evidence) for the same date are in
`.qa-artifacts/final/` (git-ignored).
