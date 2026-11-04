# Build-time configuration

The app reads its configuration from `--dart-define-from-file`. Values are
compiled into the binary, so only public values (URLs) belong here, never
secrets.

| Key | Example | Meaning |
| --- | --- | --- |
| `API_BASE_URL` | `http://localhost:8080` | API origin without `/v1`; the client calls `$API_BASE_URL/v1/...`. On web an empty value means "same origin as the page". The LiveKit URL comes from the join response. |

```bash
cp config/local.example.json config/local.json   # git-ignored, edit freely
flutter run --dart-define-from-file=config/local.json
```

Android emulator: use `http://10.0.2.2:8080` to reach the host machine.
Physical devices need the host's LAN address or a TLS edge.

Native settings that cannot come from Dart defines:

- Invite link host for app links / universal links: `deepLinkHost` in
  `android/app/build.gradle.kts` (or `-PdeepLinkHost=<host>`) and
  `DEEP_LINK_HOST` in the iOS Runner build settings. Both are placeholders
  (`calls.example.com`) until the public domain is chosen.

Invite links are not configured on the client: the API returns `inviteUrl`
(built from the server's `PUBLIC_BASE_URL`) with create, lookup, join and
rotate-code, and the app shows and shares it as is.

Release builds accept only `wss://` LiveKit URLs from the join response;
`ws://` works in debug and profile builds for the local stack.

macOS: the Release configuration stores the guest id and owner tokens in the
data-protection keychain (`keychain-access-groups` in
`macos/Runner/Release.entitlements`), which needs signing with a development
team. Debug and Profile builds are unsigned and keep that data in memory for
the session only.
