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

The client lives in `lib/` in five directories: `app` (composition: go_router routes and `getIt`), `core`,
`domain`, `data` and `presentation`. Dependencies point inward: presentation → domain ← data; `core` is shared
infrastructure and holds the DI container. `domain` imports only `equatable`.

| Layer | Contents | Rules |
| --- | --- | --- |
| `app` | `app_router.dart`: routes `/` and `/r/:code`; creates `HomeBloc`, `LobbyCubit` and `RoomBloc` through `getIt` | The only place outside `core/di` that uses `getIt` |
| `core` | `config/app_config.dart` (`AppConfig`: `API_BASE_URL` from `--dart-define-from-file`; empty on Web means the page origin; must be an `http(s)` origin, otherwise start-up fails), `di/` (get_it + injectable, `app_module.dart`), `router/app_routes.dart` (path constants and typed route extras), `time/clock.dart` (injectable `Clock`) | Build-time values are public URLs only, never secrets |
| `domain` | Entities (`Room`, `RoomCode`, `CallSnapshot`, `GuestProfile`, `RecentRoom`); ports `IRoomRepository`, `IGuestProfileRepository`, `IRecentRoomsRepository`, `CallSession`, `MediaPreview` (`services/media_preview.dart`), `IAudioService`; the sealed `Failure` hierarchy in `failures/failure.dart` | No `livekit_client`, Dio or Flutter imports |
| `data` | `RoomApiDataSource` (Dio) and DTOs, `api_failure_mapper.dart` (`DioException` and problem details to `Failure`), repositories, `LiveKitCallSession` (adapter for `CallSession`), `MediaRoomDriver` (`services/livekit_room_driver.dart`, the test seam of `LiveKitCallSession`), `LiveKitMediaPreview` (adapter for `MediaPreview`), `KeyValueStore`, `OwnerTokenStore`, `CallForegroundService`, `AudioService` | The only layer that knows Dio and the LiveKit SDK; transport exceptions do not leave it |
| `presentation` | Features `home` (`HomeBloc`) and `room` (`LobbyCubit`, `RoomBloc`) in `features/` with flutter_bloc and views; shared modules `widgets/` and `theme/` (the design system), `dialogs/` (glass dialog primitives), `shared/` (platform predicates, video rendering, `VideoVeil` over the camera), `invite/` (`InvitePanel`, `shareInvite`) and `utils/` (`failure_message.dart`: `Failure` to a localized message) | Depends on domain ports, never on `data`; `livekit_client` is imported only by `presentation/shared/participant_video.dart` (render types); the shared modules do not import `features/` |

### Design system

The screens keep the original dev-0.1.6 look and its custom widgets: dark only, the same rendering on iOS, Android,
macOS and web. Where each part lives per screen, and what changed against 0.1.6 for accessibility, is in
[`design/flows.md`](design/flows.md) §14 "dev-0.1.6 look (source of truth)".

Shared widgets are in `presentation/widgets/` and exported by `widgets.dart`:

- `GlassEffect` (`glass_effect.dart`): the glass material under every glass widget. It saturates and blurs the
  backdrop, multiplies in a tint and draws a specular rim, from Flutter primitives only (`BackdropFilter`, clip,
  canvas): no shaders and no glass package. A blur of 0 draws no backdrop filter.
- `LiquidGlassContainer` (`liquid_glass_container.dart`): the 0.1.6 frosted glass container on `GlassEffect`.
- `LiquidBounceButton` (`liquid_bounce_button.dart`): the 0.1.6 round glass icon button (call controls, refresh).
- `CustomBounceButton` and `MinTapTarget` (`custom_bounce_button.dart`): the 0.1.6 tap feedback (scale and glare);
  `MinTapTarget` centres a smaller child in a hit area of at least 48 x 48 dp.
- `CustomCard` (`custom_card.dart`) and `CustomTextField` (`custom_text_field.dart`): the 0.1.6 card and filled text
  field; with `isPassword` the field is obscured and the platform does not alter the input (no autocorrect,
  suggestions or capitalization).
- `GlassSurface` (`glass_surface.dart`): the glass panel of the newer flows on `GlassEffect`, with a minimum tint per
  `GlassVariant` (panel, or overlay over video); with high contrast it drops the blur and uses a near-opaque tint.
- `InitialsAvatar` and `AvatarTilePlaceholder` (`initials_avatar.dart`): initials on a colour derived from the
  participant, and the tile filler when the camera is off.
- `RoomTimeLogo` (`room_time_logo.dart`): the vector logo mark, optionally with the wordmark.
- `AppPressable` (`app_pressable.dart`) and `FocusRing` (`focus_ring.dart`): the accessibility base of the custom
  buttons (focus, activation with Enter, Space, Select and gamepad A, button semantics, toggled state, reduced
  motion) and the keyboard focus ring.

Other shared modules:

- `presentation/dialogs/glass_dialog.dart`: the 0.1.6 glass dialog. `showGlassDialog`, `showGlassConfirm` and
  `showGlassChoices` open it; `GlassPanel`, `GlassDialogContent`, `GlassDialogTitle`, `GlassDialogText`,
  `GlassErrorText`, `GlassButtonRow`, `GlassDialogButton` (`GlassButtonStyle`: primary, secondary, destructive) and
  `GlassTextField` build it; `GlassStatusScreen` is the full-screen status (ended call, join errors). It imports
  `l10n`.
- `presentation/shared/`: `platform.dart` (`isMobilePlatform`, `isTouchPlatform`, `isMacOSApp`),
  `participant_video.dart` (`ParticipantVideo`: renders the opaque video handle, or the avatar placeholder without
  video; the only `livekit_client` import in presentation) and `video_veil.dart` (`VideoVeil`: the frosted black veil
  over the live camera on Home).
- `presentation/invite/`: `InvitePanel` (`invite_panel.dart`), `shareInvite` and `copyWithConfirmation`
  (`invite_sharing.dart`).

Theme tokens, palettes and typography are in `presentation/theme/`; `AppTheme.dark` (`app_theme.dart`) is the dark
theme.

### Ports and adapters

- **`CallSession`** (`domain/services/call_session.dart`) is the port to the media plane, one instance per call: a
  `Stream<CallSnapshot>` plus `connect`, `leave`, microphone, camera, flip camera, speakerphone, `startAudio` (Web
  autoplay) and `dispose`. `LiveKitCallSession` (`data/services/livekit_call_session.dart`) implements it, owns the
  LiveKit room and local tracks and releases them once. Commands throw a `Failure`.
- **`Failure`** (`domain/failures/failure.dart`) is a sealed hierarchy that covers every error code of the API
  contract, plus `NetworkFailure`, `MediaDeviceFailure`, `ServerFailure` and `UnknownFailure` (codes that indicate a
  client bug map to `UnknownFailure`). The UI maps a failure to a message and never shows `toString()`.
- **`KeyValueStore`** (`data/datasources/key_value_store.dart`) is the persistent string store behind the guest
  profile, recent rooms and `OwnerTokenStore` (owner tokens, one entry per `roomId`). `SecureKeyValueStore` uses
  `flutter_secure_storage`. It switches to memory for the rest of the session only on a permanent error: the
  missing-entitlement status `errSecMissingEntitlement` (`-34018`) or a missing plugin. Any other platform error
  fails that one operation with `UnknownFailure(code: 'storage')`, and the next call tries the platform again
  (`key_value_store.dart:20-28`). Known limitation: an unsigned macOS Debug build has no `keychain-access-groups`
  entitlement, so `guestId` and owner tokens are kept in memory only and are lost on restart. The macOS Release
  build declares `keychain-access-groups` for `dev.devlet.roomtime` (`macos/Runner/Release.entitlements`)
  and therefore must be signed with a development team.
- **`CallForegroundService`** (`data/services/call_foreground_service.dart`) keeps an Android call alive in the
  background through `CallForegroundService.kt`; it does nothing on other platforms.

There is no use-case layer: BLoCs call the domain ports directly. `RoomBloc` depends on `IRoomRepository`,
`IGuestProfileRepository`, `CallSession`, `IAudioService` and `Clock`, so it is tested with fakes.

**Documented exception:** `CallParticipant.videoTrack` (`domain/entities/call_snapshot.dart`) is an opaque
`Object?`, and so is `MediaPreviewState.videoTrack` (`domain/services/media_preview.dart`). Only the widget that
renders video downcasts it to the LiveKit track and uses LiveKit render types; no other presentation code uses the
SDK. The camera preview is owned by the `MediaPreview` port and its adapter `LiveKitMediaPreview`
(`data/services/livekit_media_preview.dart`), so presentation never creates SDK tracks.

### Composition root

- `main.dart` sets the path URL strategy (invite links are `/r/<code>`), calls `configureDependencies()` and runs
  `MaterialApp.router` with `appRouter` from `app/app_router.dart`.
- `core/di` registers everything with injectable. `AppConfig` is an eager singleton, so a bad `API_BASE_URL` fails at
  start-up. There is one `Dio` (platform trust store, no pinning) and one `FlutterSecureStorage`. `CallSession`,
  `MediaPreview`, `HomeBloc`, `LobbyCubit` and `RoomBloc` are factories (one per screen, call or preview); the rest
  are lazy singletons (`core/di/injection.config.dart`).
- `app/app_router.dart` defines `/` and `/r/:code` with the path constants from `core/router/app_routes.dart`. A
  malformed code redirects to `/`, other spellings are normalized to the canonical path, and route arguments travel
  only in memory as typed extras (`RoomRouteExtra`, `HomeRouteExtra`). It imports the presentation screens and
  creates `HomeBloc`, `LobbyCubit` and `RoomBloc` through `getIt`.
- **Invite link.** The server is the only builder of the invite link (its public base URL + `/r/` + dashed code).
  Create, update, rotate-code, lookup and join all return `inviteUrl`; the client parses it into `Room.inviteUrl`
  (`data/models/room_dtos.dart`) and shows it as is.

## Trust and privacy

- Passwords, invite codes and tokens never appear in URLs or logs; a password goes only in the join request body.
- The device keeps its own `guestId`, display name, recent rooms and owner tokens in secure storage
  (`KeyValueStore`, `OwnerTokenStore`).
- Transport encryption only: the backend operator's SFU sees media in plain form. Optional media end-to-end
  encryption with LiveKit frame encryption is **(planned)**; no UI or document claims end-to-end encryption.
