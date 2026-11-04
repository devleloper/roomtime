# Changelog

All notable changes to the RoomTime client are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html). Release tags are `vX.Y.Z` and match the `version` in
`pubspec.yaml`.

## [Unreleased]

Release 1 of the app formerly called FamilyCalls.

### Added

- Room flows on the room API v1 ([docs/api/openapi.yaml](docs/api/openapi.yaml)): create a room with an optional
  password, join by 10-letter code or invite link (`/r/<code>`), lobby with device preview and password entry,
  call with host controls, reconnect, ended and error screens.
- Host controls: mute a participant's microphone, remove a participant (optionally with a ban), revoke the invite
  and issue a new code, end the room for everyone.
- Guest profile with a display name, recent rooms, owner tokens in secure storage.
- Clean architecture layers (core, domain, data, presentation) with get_it/injectable, flutter_bloc and go_router;
  LiveKit behind a `CallSession` port.
- Accessibility inside the original custom widgets (`LiquidGlassContainer`, `LiquidBounceButton`,
  `CustomBounceButton`, `CustomCard`, `CustomTextField`, `DynamicIslandBadge`) with the same API and look:
  semantics, keyboard activation and focus, 48 dp targets and reduced motion.
- English and Russian localization (gen-l10n), including the camera and microphone permission prompts.
- Background audio on iOS, a foreground service for calls on Android, invite links as app links and universal
  links.
- RoomTime brand identity: Door swing mark on brand blue `#00AEFF`, app icons, a dark splash and favicon for every
  platform, built by a reproducible script, and original join/leave sounds.
- Inter 4.1 variable font for the web build (SIL Open Font License 1.1), so the web app fetches no fonts from a
  CDN; native platforms keep the system font.
- Apple privacy manifests and Android release signing from `key.properties`.

### Changed

- **Breaking:** renamed to RoomTime: Dart package `roomtime`, app ids `dev.devlet.roomtime`.
- **Breaking:** requires the room API v1; rooms are no longer identified by their name and there is no public room
  list.
- Web release builds work again: the glass effect of the original widgets is drawn without shaders
  (`GlassEffect`), so `liquid_glass_renderer` is no longer used; the look is unchanged.

### Removed

- **Breaking:** the custom API-layer "E2EE" client and certificate pinning (transport security is TLS), user
  accounts and authentication.
- `envied` build-time secrets, replaced by `--dart-define-from-file` with public values only.
- The previous sounds of unknown provenance, and the unused `device_info_plus`, `rxdart`, `cryptography` and
  `cupertino_icons` dependencies.

[Unreleased]: https://github.com/devleloper/roomtime/commits/main
