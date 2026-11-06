# RoomTime client architecture

This page describes the release-1 architecture of the RoomTime client as it exists in the code. Items marked
**(planned)** do not exist in the code yet.

## Backend

The client needs a RoomTime backend, which is not part of this repository:

- **Room API** over HTTPS: create, look up, join and moderate rooms. The contract is
  [`api/openapi.yaml`](api/openapi.yaml) (OpenAPI 3.1, errors as RFC 9457 problem details). The client sends only
  what the contract defines and maps every documented error code to a localized message.
- **LiveKit SFU** for media: the join response carries a short-lived LiveKit token and the WebSocket URL
  (`wss://`, or `ws://` on a loopback host in development). Media is protected by DTLS-SRTP between the device and
  the SFU.

`API_BASE_URL` (build-time, see [`config/README.md`](../config/README.md)) points the app at the API; on the web an
empty value means the origin that serves the app. Invite links `https://<host>/r/<code>` open the lobby directly.

## Client layers

The client lives in `lib/` in five directories next to `main.dart`: `core`, `domain`, `data`, `presentation`
and `l10n`. Dependencies of the layers point inward: presentation → domain ← data. `domain` imports no package other
than `freezed_annotation`. `core/config` and `core/utils` import no other layer; `core/router/app_routes.dart` imports
domain entities; `core/di` and `core/router/app_router.dart` are the composition root and between them import every
layer (see [Composition root](#composition-root)).

| Layer | Contents | Rules |
| --- | --- | --- |
| `core` | `config/app_config.dart` (`AppConfig`: `API_BASE_URL` from `--dart-define-from-file`; empty on Web means the page origin; must be an `http(s)` origin, otherwise start-up fails), `di/` (get_it + injectable: `injection.dart` with `getIt` and `configureDependencies()`, `app_module.dart`, generated `injection.config.dart`), `router/app_router.dart` (`appRouter`), `router/app_routes.dart` (`AppRoutes` path constants, typed route extras `RoomRouteExtra` and `HomeRouteExtra`, `PendingHomeNotice`), `utils/clock.dart` (injectable `Clock`), `utils/dev_log.dart` (`devLog`), `utils/platform.dart` (`isMobilePlatform`, `isTouchPlatform`, `isMacOSApp`) | Build-time values are public URLs only, never secrets; only `core/di` and `core/router/app_router.dart` use `getIt` |
| `domain` | Entities: `room.dart` (`RoomSummary`, `RoomInfo`, `CreatedRoom`, `RoomJoin`, `CreateRoomParams`, `RoomPatch`, `PasswordChange`, `RotatedCode`), `room_code.dart` (`RoomCode`), `room_password.dart` (`RoomPassword`), `call_snapshot.dart` (`CallSnapshot`, `CallParticipant`), `guest_profile.dart` (`GuestProfile`), `recent_room.dart` (`RecentRoom`); ports in `repositories/` (`RoomRepository`, `GuestProfileRepository`, `RecentRoomsRepository`) and `services/` (`CallSession`, `MediaPreview`, `AudioService`); the sealed `Failure` hierarchy in `failures/failure.dart` | No `livekit_client`, Dio or Flutter imports |
| `data` | `network/` (`RoomApiDataSource` on Dio; `api_failure_mapper.dart`: `DioException` and problem details to `Failure`), `local/` (`KeyValueStore` and `SecureKeyValueStore`, `OwnerTokenStore` and `OwnerTokenRecord`), `models/room_dtos.dart` (wire DTOs), `repositories/` (`ApiRoomRepository`, `LocalGuestProfileRepository`, `LocalRecentRoomsRepository`), `services/` (`LiveKitCallSession`, the adapter for `CallSession`; `MediaRoomDriver` and `LiveKitRoomDriver` in `livekit_room_driver.dart`, the test seam of `LiveKitCallSession`; `liveKitRoomOptions` in `livekit_room_options.dart`; `LiveKitMediaPreview`, the adapter for `MediaPreview`, with its seam `PreviewDevices` in `preview_devices.dart`; `AssetAudioService`, the adapter for `AudioService`; `CallForegroundService`) | The only layer that calls Dio and the LiveKit SDK (`core/di/app_module.dart` constructs the `Dio`; `ParticipantVideo` uses LiveKit render types); transport exceptions do not leave it |
| `presentation` | Features `home` (`HomeBloc`) and `room` (`LobbyCubit`, `RoomBloc`) in `features/<feature>/{bloc,view,widgets}` with flutter_bloc; `features/room/view/room_exit_guard.dart` (`RoomExitGuard`), `features/room/widgets/room_title.dart` (`roomTitle`); shared modules `widgets/` and `theme/` (the design system) | Depends on domain ports, never on `data`; `livekit_client` is imported only by `presentation/widgets/participant_video.dart` (render types); `widgets/` and `theme/` do not import `features/` |
| `l10n` | ARB catalogs `app_en.arb` and `app_ru.arb`, generated `app_localizations*.dart`, `failure_message.dart` (`FailureMessage.localizedMessage`: `Failure` to a localized message), `l10n.dart` (`context.l10n`; re-exports both) | Imports only `domain/failures` from the app layers |

### Design system

The screens keep the original dev-0.1.6 look and its custom widgets: dark only, the same rendering on iOS, Android,
macOS and web. Where each part lives per screen, and what changed against 0.1.6 for accessibility, is in
[`design/flows.md`](design/flows.md) §14 "dev-0.1.6 look (source of truth)".

Shared widgets are in `presentation/widgets/`, one import per file (there is no barrel file):

- `GlassEffect` (`glass_effect.dart`): the glass material under every glass widget. It saturates and blurs the
  backdrop, multiplies in a tint and draws a specular rim, from Flutter primitives only (`BackdropFilter`, clip,
  canvas): no shaders and no glass package. A blur of 0 draws no backdrop filter.
- `glass_surface.dart`: `LiquidGlassContainer` (the 0.1.6 frosted glass container on `GlassEffect`), `GlassPanel`
  (the 0.1.6 dialog panel on `LiquidGlassContainer`), `GlassSurface` (the glass panel of the newer flows on
  `GlassEffect`, with a minimum tint per `GlassVariant`, panel or overlay over video; with high contrast it drops the
  blur and uses the higher fallback minimum tint), `GlassHudPill` (icon and message pill) and `VideoVeil` (the frosted
  veil over live video).
- `LiquidBounceButton` (`liquid_bounce_button.dart`): the 0.1.6 round glass icon button (call controls, refresh).
- `CustomBounceButton` and `MinTapTarget` (`custom_bounce_button.dart`): the 0.1.6 tap feedback (scale and glare);
  `MinTapTarget` centres a smaller child in a hit area of at least 48 x 48 dp.
- `CustomTextField` (`custom_text_field.dart`): the 0.1.6 filled text field; with `isPassword` the field is obscured
  and the platform does not alter the input (no autocorrect, suggestions or capitalization).
- `glass_dialog.dart`: the 0.1.6 glass dialog. `showGlassDialog`, `showGlassConfirm` and `showGlassChoices` open it;
  `GlassDialogContent`, `GlassDialogTitle`, `GlassDialogText` and `GlassErrorText` build it; `GlassStatusScreen` is
  the full-screen status (ended call, join errors).
- `glass_button.dart`: `GlassDialogButton` (`GlassButtonStyle`: primary, secondary, destructive) and `GlassButtonRow`.
- `GlassTextField` (`glass_text_field.dart`): the dialog text field; with `obscure` it hides the input behind a
  visibility toggle and turns off autocorrect and suggestions. It imports `l10n`.
- `InitialsAvatar` and `AvatarTilePlaceholder` (`initials_avatar.dart`): initials on a colour derived from the
  participant, and the tile filler when the camera is off.
- `ParticipantVideo` (`participant_video.dart`): renders the opaque video handle, or the avatar placeholder without
  video; the only `livekit_client` import in presentation.
- `InvitePanel` (`invite_panel.dart`) and `shareInvite`, `copyWithConfirmation` (`invite_sharing.dart`): the invite
  link and code with share and copy actions.
- `AppPressable` (`app_pressable.dart`) and `FocusRing` (`focus_ring.dart`): the accessibility base of the custom
  buttons (focus, activation with Enter, Space, Select and gamepad A, button semantics, toggled state, reduced
  motion) and the keyboard focus ring.

Theme tokens, palettes and typography are in `presentation/theme/`; `AppTheme.dark` (`app_theme.dart`) is the dark
theme.

### Ports and adapters

- **`CallSession`** (`domain/services/call_session.dart`) is the port to the media plane, one instance per call: a
  `Stream<CallSnapshot>` plus `connect`, `leave`, microphone, camera, flip camera, speakerphone, `startAudio` (Web
  autoplay) and `dispose`. `LiveKitCallSession` (`data/services/livekit_call_session.dart`) implements it, owns the
  LiveKit room and local tracks and releases them once. Commands throw a `Failure`.
- **`Failure`** (`domain/failures/failure.dart`) is a sealed hierarchy that covers every error code of the API
  contract, plus `NetworkFailure`, `MediaDeviceFailure`, `ServerFailure` and `UnknownFailure` (codes that indicate a
  client bug map to `UnknownFailure`). The UI maps a failure to a message with `localizedMessage`
  (`l10n/failure_message.dart`) and never shows `toString()`.
- **`KeyValueStore`** (`data/local/key_value_store.dart`) is the persistent string store behind the guest
  profile, recent rooms and `OwnerTokenStore` (owner tokens, one entry per `roomId`). `SecureKeyValueStore` uses
  `flutter_secure_storage`. It switches to memory for the rest of the session only on a permanent error: the
  missing-entitlement status `errSecMissingEntitlement` (`-34018`) or a missing plugin. Any other platform error
  fails that one operation with `UnknownFailure(code: 'storage')`, and the next call tries the platform again
  (`key_value_store.dart:28-37,63-92`). Known limitation: an unsigned macOS Debug build has no `keychain-access-groups`
  entitlement, so `guestId` and owner tokens are kept in memory only and are lost on restart. The macOS Release
  build declares `keychain-access-groups` for `dev.devlet.roomtime` (`macos/Runner/Release.entitlements`)
  and therefore must be signed with a development team.
- **`CallForegroundService`** (`data/services/call_foreground_service.dart`) keeps an Android call alive in the
  background through `CallForegroundService.kt`; it does nothing on other platforms.

There is no use-case layer: BLoCs call the domain ports directly. `RoomBloc` depends on `RoomRepository`,
`GuestProfileRepository`, `CallSession`, `AudioService` and `Clock`, so it is tested with fakes
(`test/helpers/fakes.dart`).

**Documented exception:** `CallParticipant.videoTrack` (`domain/entities/call_snapshot.dart`) is an opaque
`Object?`, and so is `MediaPreviewState.videoTrack` (`domain/services/media_preview.dart`). Only the widget that
renders video downcasts it to the LiveKit track and uses LiveKit render types; no other presentation code uses the
SDK. The camera preview is owned by the `MediaPreview` port and its adapter `LiveKitMediaPreview`
(`data/services/livekit_media_preview.dart`), so presentation never creates SDK tracks.

### Composition root

The composition root lives in `core`, not in a separate layer: `core/di` (through the generated
`injection.config.dart`) imports `data` and `presentation`, and `core/router/app_router.dart` imports
`presentation`. No other code uses `getIt`.

- `main.dart` sets the path URL strategy (invite links are `/r/<code>`), calls `configureDependencies()` and runs
  `RoomTimeApp`: `MaterialApp.router` with `appRouter` from `core/router/app_router.dart` and `AppTheme.dark`.
- `core/di` registers everything with injectable. `AppConfig` is an eager singleton, so a bad `API_BASE_URL` fails at
  start-up. There is one `Dio` (platform trust store, no pinning) and one `FlutterSecureStorage`. `CallSession`,
  `MediaPreview`, `HomeBloc`, `LobbyCubit` and `RoomBloc` are factories (one per screen, call or preview); the rest
  are lazy singletons (`core/di/injection.config.dart`).
- `core/router/app_router.dart` defines `/` and `/r/:code` with the path constants from
  `core/router/app_routes.dart`. A malformed code redirects to `/` and posts `HomeNotice.invalidInviteLink` to
  `PendingHomeNotice`, other spellings are normalized to the canonical path, and route arguments travel only in
  memory as typed extras (`RoomRouteExtra`, `HomeRouteExtra`). It imports the presentation screens and blocs, creates
  `HomeBloc` through `getIt`, and hands `getIt` factories for `MediaPreview`, `RoomBloc` and `LobbyCubit` to
  `HomeScreen` and `RoomScreen`. It keeps one `RoomExitGuard` per room page and asks it in `onExit` whether the page
  may close.
- **Invite link.** The server is the only builder of the invite link (its public base URL + `/r/` + dashed code).
  Create, update, rotate-code, lookup and join all return `inviteUrl`; the client parses it with `HttpUriConverter`
  (`data/models/room_dtos.dart`) into the `inviteUrl` of `RoomSummary`, `RoomInfo`, `CreatedRoom` and `RotatedCode`
  and shows it as is.

### Generated code

Generated Dart files are committed next to their sources, so a fresh clone builds without `build_runner`; never edit
them by hand.

| Files | Generator | Sources |
| --- | --- | --- |
| `*.freezed.dart` | freezed | Domain entities (all but `RoomPassword`), `Failure`, `CallConnectOptions`, `MediaPreviewState`, `OwnerTokenRecord`, the DTOs, bloc states and events |
| `*.g.dart` | json_serializable (`build.yaml`: `explicit_to_json: true`) | The DTOs in `room_dtos.dart`, `RecentRoom`, `GuestProfile`, `OwnerTokenRecord` |
| `core/di/injection.config.dart` | injectable_generator | The injectable annotations (`@Injectable`, `@LazySingleton`, `@singleton`, `@module`) |
| `l10n/app_localizations*.dart` | `flutter gen-l10n` (`l10n.yaml`) | `l10n/app_en.arb`, `l10n/app_ru.arb` |

After you change an annotated class, regenerate from the repository root and commit the result:

```bash
dart run build_runner build --delete-conflicting-outputs
```

After you change an ARB file, run `flutter gen-l10n`. CI regenerates the code and fails when any
generated file differs from the committed one or is missing from git (`.github/workflows/ci.yml`, "Generated code is up
to date").

## Trust and privacy

- Passwords and owner tokens never appear in URLs or logs; the invite code appears only in the invite link path
  (`/r/<code>`) and is never logged; a password goes only in the join request body.
- The device keeps its own `guestId`, display name, recent rooms and owner tokens in secure storage
  (`KeyValueStore`, `OwnerTokenStore`).
- Transport encryption only: the backend operator's SFU sees media in plain form. Optional media end-to-end
  encryption with LiveKit frame encryption is **(planned)**; no UI or document claims end-to-end encryption.
