# Integration regression list

Live-stack suites (no mocks). Start a RoomTime backend reachable at the `API_BASE_URL` of
`config/local.json`, then run from the repository root:

```
flutter test integration_test/flows/<file> -d <device> --dart-define-from-file=config/local.json
```

Finders use the app's localizations (`l10nOf(tester)` in `support/live_app.dart`), so the suite runs on
simulators set to English or Russian.

| Flow | Test file | Platforms |
| --- | --- | --- |
| Create a room, look it up by code, lobby (open room, host of a password room, guest of a password room, unknown code) | `flows/create_lookup_lobby_test.dart` | iOS Simulator, Android emulator |

The backend rate-limits room creation per IP address; run the suite against a development backend.
