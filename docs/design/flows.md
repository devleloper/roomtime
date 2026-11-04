# Room flows: screen spec

**Source of truth for the look: the original dev-0.1.6 screens** ([section 14](#14-dev-016-look-source-of-truth),
reference: the `lib/` of dev-0.1.6, commit `3b3c480`). Sections 1-11 describe the screens as built; §12-13 hold the
accessibility checklist and open questions.

Status: v1 · 2026-11-04 · Owner: ux-ui-designer
Contract: [openapi.yaml](../api/openapi.yaml) (codes, links, passwords, errors); media E2EE is planned.
Tokens and components: [tokens.md](tokens.md).
Copy is a **proposal** in English and Russian: product-analyst decides wording, i18n-engineer moves it to ARB. Keys
are suggestions for the ARB names.

## 0. Conventions

- **Window size classes**: compact < 600, medium 600–839, expanded ≥ 840 (large/extra-large follow expanded unless
  stated). Measured with `WindowSizeClass.of(context)`.
- **Input modes**: touch, pointer (mouse/trackpad), keyboard. Hover affordances and tooltips for pointer; visible
  focus and shortcuts for keyboard. Never infer input from width: an iPad with a keyboard is "expanded + keyboard";
  a narrow desktop window is "compact + pointer + keyboard".
- **Platforms**: Web, iOS, Android, macOS. Mobile-only controls: camera flip, earpiece/speaker routing.
- **Theme**: dark only, as in 0.1.6 (`theme: AppTheme.dark, themeMode: ThemeMode.dark`, §14); the light schemes exist
  for tests and a later light mode, no screen uses them.
- **Navigation**: two routes only, `/` Home (create and join happen there, in glass dialogs) and `/r/:code` lobby →
  call → ended. Invite links open `/r/:code` directly. Nothing secret in routes (no password; the E2EE key lives in
  the fragment and is removed after reading).
- **Text scale**: every screen works at 200 % on a 320 dp wide window: content scrolls, nothing is clipped, no fixed
  heights around text.
- **Reduced motion**: all transitions instant (see tokens.md, Motion).
- **Never**: raw exception text, "end-to-end"/"encrypted" wording without verified media E2EE, passwords in
  share text or URLs.

---

## 1. Home

Route `/` (`HomeScreen`). One screen holds everything that happens before a room: the camera backdrop, the title,
Create Room, join by code and the recent rooms. There is no separate create route.

### Layout

| Window | Layout |
| --- | --- |
| Phone (touch platform and width ≤ 600) | `HomeMobileLayout`: full-screen frosted veil (`VideoVeil`) over the camera. Top row: title (`appName`, 34 bold, tracking -0.5, header) and the 48 dp glass circle for the camera preview (`LiquidBounceButton`, `toggled`). Below, in a scrolling list: the solid `#00AEFF` Create Room CTA (radius 16, 17 w600), "Join with a code" label + `JoinWithCodeField`, "Recent" label + `RecentRoomsList`. |
| Tablet / desktop / web wider than 600 | `HomeDesktopLayout`: 380 dp frosted sidebar on the start side, the camera sharp beside it. Title 28 bold, CTA radius 12 / 16 w600, section labels 13 w600 white 70 %, the camera circle 28 dp drawn inside a 48 dp target. |

Text scale 200 %: the list scrolls; the title ellipsizes on one line (the full name stays in semantics).

### Camera backdrop

- The preview starts by itself only when camera access is already granted. Home never prompts on its own; a tap on
  the camera circle asks (first time) or toggles the preview. Web and macOS (no permission query) wait for the tap.
- The camera stops while another route covers Home, while the app is in the background and when the circle is
  turned off. Microphone is never opened on Home.
- Black until the first frame. Denied or no camera: the veil stays on black and the circle is hidden; never an error
  over the camera.

### Join by code

`JoinWithCodeField` = `CustomTextField` (hint `homeJoinLabel`, the field's accessible name) + Join. Accepts a code or
a full invite link. Enter / the keyboard Go action joins. The input is checked locally (`RoomCode`) before any
request: `homeInvalidCode`, `homeNotARoomLink` appear under the field in red and focus returns to it. While the
lookup runs the button reads `homeChecking`; on success Home navigates to `/r/:code` with the room summary (no
second lookup). Lookup failures show the §10 copy under the field.

A malformed invite link that opened the app redirects to Home with a one-shot SnackBar (`homeInvalidInviteLink`).

### Recent rooms

Rooms this device created or joined, newest first, as the plain rows of the 0.1.6 room list: name 17 w600, a
`videocam` caption with the age (`homeJustNow`, `homeMinutesAgo`, ...) and `homeRecentHost` for rooms you host, 1 px
dividers. A row opens `/r/:code` (the lobby). The trailing button forgets the room locally at once and shows a
SnackBar with Undo (`homeRecentRemoved`, `homeUndo`). Empty: `homeRecentEmpty`.

### Accessibility

Title is a header; the camera circle has a name, tooltip and `toggled`; each recent row is one node
(`homeRecentRow`) plus the labelled remove button (`homeRecentRemoveFor`). Keyboard order: camera circle, Create
Room, code field, Join, recent rows.

## 2. Create room (dialog on Home)

Create Room opens the glass dialog (`showCreateRoomDialog` → `showGlassDialog`, max width 420, title
`homeCreateRoom`) over Home; Home stays underneath. The same dialog has two steps.

### Step 1: form

| Field | Rule |
| --- | --- |
| Room name (`homeCreateNameLabel`) | optional, max 40 characters; empty means an unnamed room |
| Password (`homePasswordOptional`) | optional; empty = no password; otherwise `RoomPassword` length rules, taken verbatim (no trim, no autocorrect, smart punctuation off), show/hide toggle |

Buttons (`GlassButtonRow`, secondary first, primary last; stacked at large text): Cancel (`homeCancel`), Create
(`homeCreate`; `homeCreateRetry` after a failure). Password errors: `homeCreatePasswordTooShort` /
`homeCreatePasswordTooLong` under the field. A create failure shows the §10 message in the dialog and keeps the
input.

**No limit fields.** Max participants and room lifetime are not chosen by the user: the server applies its defaults
(OpenAPI: 10 participants, 240 minutes). The `InputField.maxParticipants` / `lifetime` messages only map server
validation errors.

### Step 2: invite

After the room is created the dialog switches to `inviteReady` with the invite panel (§3) and two buttons: Done
(`inviteDone`, closes the dialog, stays on Home; the room is in Recent) and Join (`homeJoin`, opens `/r/:code` as
host).

## 3. Invite

`InvitePanel` is shared by the create dialog (step 2) and the in-call Invite dialog (`inviteTitle`, opened from the
glass circle in the top corner of the call).

- Link (`inviteLinkLabel`) with Copy link (`inviteCopyLink` → HUD pill `inviteLinkCopied`, black 70 %, live region,
  shown above an open dialog).
- Code (`inviteCodeLabel`, shown grouped for reading) with Copy code (HUD pill `inviteCodeCopied`).
- Share (`inviteShare`): the system share sheet where available, text `inviteShareText`, subject
  `inviteShareSubject`.
- Password rooms: `invitePasswordNote`; the password is never part of the link, code or share text.
- Host only, in the call: Change code (`inviteRotate`) → confirmation (`inviteRotateTitle`, `inviteRotateBody`,
  `inviteRotateConfirm`); old links stop working.

## 4. Lobby (pre-join)

Route `/r/:code` (`RoomScreen` → `LobbyView`). Reached from Join on Home, an invite link, a recent row or Join in
the create dialog. Each attempt gets fresh blocs, so Rejoin / Try again always make a new join request.

### Layout

The local camera fills the screen behind the veil (black with the `InitialsAvatar` when the camera is off); the
glass dialog panel sits centred over it. Top start: Back (`roomBack`) to Home. While a link without a summary is
looked up: a progress indicator (`roomFinding`).

Panel content, top to bottom: room title (`roomTitleUnnamed` for unnamed rooms), `roomHostNotice` /
`roomLockedNotice` when relevant, permission notices, display name (`roomNameLabel`; `roomNameRequired`,
`roomNameTooLong`), password when the room has one (`roomPasswordLabel`, helper `roomPasswordHelper`), mic and
camera `MediaControlButton`s (toggle state, off icon, red 40 % tint when off), then Cancel (`roomCancel`) and Join
(`roomJoin`; `roomJoining` while connecting).

### Permissions and devices

- Not asked yet: `roomPermExplainer` with Allow (`roomPermAllow`); the system prompt only after that tap.
- Blocked: `roomCameraBlocked*` / `roomMicBlocked*` per platform (web, desktop, mobile), with Open settings
  (`roomOpenSettings`) where the OS has it. Access is re-read when the app returns to the foreground.
- From the Join tap until the attempt fails, no device control can reopen the camera (the preview is being handed to
  the call).

### Password and lock-out

Wrong password: `roomWrongPassword` under the field, the field is cleared (verbatim retype). Missing:
`roomPasswordRequired`. Too many attempts: the form is disabled with a countdown (`roomTooManyAttempts(mm:ss)`),
announced once, then `roomCanTryAgain`.

### Focus

Keyboard-first devices focus the empty name field; touch devices (mobile web included) never autofocus. Enter in a
field joins. Ctrl/⌘+D and +E toggle mic and camera (§11).

## 5. In call

`CallView` in the 0.1.6 look.

### Layout

- Video full screen: alone → own camera cover; 2 people → the other person full screen and your camera as a
  draggable PiP; 3+ → grid (`MissionControlGrid`).
- Top: room name badge (`DynamicIslandBadge`; on iPhones with a Dynamic Island in portrait it grows out of the island, else
  slides in). Top corners: Participants glass circle (name `roomParticipants, roomParticipantCount`) and Invite
  glass circle (`roomInvite`).
- Bottom: `MediaControlsRow` of round glass controls, 20 dp gaps, never below 48 dp: mic, camera, flip (touch
  devices, `roomFlip`), speaker / earpiece (phones), hang up (`roomLeave`, `#FF453A` 40 %). Off controls are tinted
  red.
- Alone: the glass dialog `roomAlone` / `roomAloneBody` with Copy link and Share.

### Chrome auto-hide

Touch devices only. Never while a screen reader is on, focus or the pointer is in the controls, a dialog is open,
the connection is being restored, the user is alone, or motion is reduced.

### Tiles

One semantics node per tile: name (`roomNameYou` / `roomNameYouHost` for yourself), `roomSpeaking`, `roomMicOff`,
`roomCamOff`, `roomWeakConnection`. Speaker glow under the video (off in 1:1). Long-press on a remote tile opens the
host options when you are the host (§6).

### Notices

Join/leave are HUD pills (`CallNotice`, glass black 70 %, live region): `roomJoined`, `roomJoinedMany` (bursts),
`roomLeft`. Room changes and failed host actions are SnackBars: `roomMuted`, `roomRemoved`, `roomLocked` /
`roomUnlocked`, `roomPasswordSet` / `roomPasswordRemoved`, `roomInviteRotated`. State lines use the HUD glass (black
80 %, white underlined action, live region): see §8 and `roomSoundBlocked` + `roomTurnOnSound` (web autoplay),
`roomMicUnavailable*` + Try again, `roomExpiresSoon` + Dismiss.

## 6. Participants and host actions

- Participants glass circle → glass dialog `roomPeopleTitle(n)`: rows in the 0.1.6 row style (17 w600, then 14
  white 70 %) with You / Host marks and mic state; Close (`roomClose`). The list stays live while open.
- Host only, per remote row: options button (`roomOptionsFor(name)`); the same choices open on a long-press of the
  tile. Choices: Mute (`roomMute`), Remove (`roomRemove`) → confirmation `roomRemoveTitle(name)` with the Ban
  checkbox (`roomBan`, `roomBanNote`), destructive `roomRemoveConfirm`.
- Host only, room settings in the same dialog (`roomRoomSettings`): Lock switch (`roomLock`, `roomLockSub`),
  Set / Change password (password dialog, verbatim, `RoomPassword` rules), Remove password (confirmation), Change
  invite code (§3).
- Every action reports through the §5 notices; failures use §10 copy.

## 7. Leaving and ending

- Participant: hang up leaves at once → §9.
- Host: hang up opens the glass choices dialog `roomLeaveSheetTitle`: Leave (`roomLeaveLeave`, others stay) or End
  for everyone (`roomLeaveEnd`) → destructive confirmation (`roomLeaveConfirmTitle`, focus on Cancel).
- System Back and browser history run the same flow; leaving lets the route go, ending for everyone stays to show
  the result. No keyboard shortcut leaves or ends a call.

## 8. Reconnecting

Connection lost: the HUD line `roomReconnecting` with Leave; video freezes in place, controls stay up. Restored:
`roomReconnected` (wifi icon), then hides. If reconnection gives up, the call ends on the §9 screen
(`roomEndedConnectionLost`, Rejoin).

## 9. Ended

`EndedView` = `GlassStatusScreen`: black, the glass panel in the middle with an icon, title, optional message and
buttons (secondary first, primary last).

| Reason | Title | Buttons |
| --- | --- | --- |
| You left | `roomEndedLeft` | Home, **Rejoin** (back to the lobby, fresh request, same devices) |
| You ended it for everyone | `roomEndedByYou` | New room (Home + create dialog), **Home** |
| The host ended it | `roomEndedByHost` + body | **Home** |
| You were removed | `roomEndedRemoved` | **Home** |
| Room expired | `roomEndedExpired` + body | New room, **Home** |
| Joined on another device | `roomEndedElsewhere` + body | Use here (`roomUseHere`, rejoins), **Home** |
| Connection lost | `roomEndedConnectionLost` + body | Home, **Rejoin** |

## 10. Errors

Never raw exception text; every `Failure` maps through `failure_message.dart`.

- **Full screen** (`JoinErrorView`, the same glass status frame as §9) when the lobby cannot help: room not found /
  invalid / expired / revoked share one message on purpose (`roomNotFoundTitle`); full
  (`roomFullBody(max)`, Try again); locked (`roomLockedTitle`, Try again); banned (`roomBannedTitle`). Buttons: Home
  and, where useful, Try again.
- **Inline** everywhere else: under the Home code field (lookup), in the create dialog, under the lobby fields
  (password, name, server busy, network), in the host dialogs.
- Network vs. other: `roomNoConnectionTitle` vs. `roomSomethingWrongTitle` with the mapped message.

## 11. Keyboard (web and desktop)

| Keys | Action | Where |
| --- | --- | --- |
| Ctrl/⌘+D | mic on/off | lobby, call |
| Ctrl/⌘+E | camera on/off | lobby, call |
| Ctrl/⌘+Alt+P | participants | call |
| Ctrl/⌘+/ | shortcut help (`roomShortcutsTitle`) | call |
| Enter | join (code field, lobby fields), activate the focused control | Home, lobby, dialogs |
| Escape | close the glass dialog, focus back to its opener | dialogs |

Shortcuts are modifier chords only and are off while a text field has focus (Ctrl+D / Ctrl+E keep their editing
meaning there). ⌘ on macOS and on web on a Mac, Ctrl elsewhere. Tab order follows the visual order; every glass
control shows the focus ring.

## 12. Accessibility checklist per screen

| Check | Rule |
| --- | --- |
| Names | Every icon-only control has a label (`LiquidBounceButton` / `CustomBounceButton` `semanticLabel`, `MediaControlButton` label, `IconButton.tooltip`). |
| States | Toggles expose on/off (`toggled`), disabled actions `enabled: false`. |
| Targets | ≥ 48 dp; ≥ 8 dp between adjacent call controls. |
| Contrast | Pairs from tokens.md only; text over video only on `videoScrim`. |
| Text scale | 200 % at 320 dp: content scrolls; call controls are icon-only (names in semantics and tooltips). |
| Focus | Visible ring for keyboard; logical order; no traps; Esc closes overlays; focus returns to the invoker. |
| Motion | `AppMotion.resolve`; reduced motion makes transitions instant. |
| Announcements | Errors, HUD state lines, join/leave and copy notices are live regions, announced once. |
| RTL | Directional padding; the controls order mirrors; the `call_end` icon is not mirrored. |

## 13. Open questions

1. Listen-only join when the mic is denied (§4): proposal yes, joins muted. Owner: product-analyst.
2. Recent rooms on Home: storage of codes locally and what "remove from recent" means. Owner: product-analyst.
3. Product name: decided 2026-11-04, **RoomTime** (`appName`, the Home title).
4. Font: decided 2026-11-04 (VIS-01): platform system font on native (SF Pro / Roboto, as 0.1.6), bundled Inter on
   web only (no fonts.gstatic.com). The Inter files still ship in native bundles (pubspec assets are shared) for the
   wordmark.

## 14. dev-0.1.6 look (source of truth)

The product keeps the dev-0.1.6 FaceTime-like screens and widgets with their original API and look. Measurements,
colors and layout per screen: the dev-0.1.6 sources (`git show 3b3c480:lib/...`). This section
lists where each part lives and what was added to 0.1.6 for accessibility and web; sections 1-11 set content, states
and copy. Identical on iOS, Android, macOS and web. Dark only. Preview of the shared widgets:
`img/original-widgets.png`.

Shared widgets (`lib/presentation/widgets/`): `LiquidGlassContainer`, `LiquidBounceButton`,
`CustomBounceButton`, `CustomCard`, `CustomTextField`, `GlassEffect` (the FakeGlass look without shaders),
`GlassSurface`, `InitialsAvatar`, `RoomTimeLogo`, and the internals `AppPressable`, `FocusRing`. Room widgets of 0.1.6
in `features/room/widgets/`: `DynamicIslandBadge`, `DraggablePipView`, `MissionControlGrid`.
Glass dialogs: `lib/presentation/dialogs/glass_dialog.dart`. Tokens: [tokens.md](tokens.md).

### Home

| Window | Layout |
| --- | --- |
| Phone (compact) | Full-screen frosted veil over the front camera (`HomeMobileLayout`, `VideoVeil`). Title with a 48 dp glass circle (camera preview), the solid `#00AEFF` "Create Room" CTA (radius 16), join with a code (`JoinWithCodeField`: `CustomTextField` + Join), recent rooms as plain rows with 1 px dividers where 0.1.6 listed public rooms. |
| Tablet / desktop (medium+) | 380 dp frosted sidebar on the start side (`HomeDesktopLayout`), live camera sharp beside it. Title, CTA radius 12, "Rooms" label 13 w600 white 70 % with a 28 dp glass circle (48 dp target). |

Camera: only under the [§1 Camera backdrop](#camera-backdrop) rules; black until the first frame; no permission or
no camera keeps the veil on black (never a raw error over the camera, a 0.1.6 defect). Create/Join dialogs:
`showGlassDialog` panel (blur 30, surface 50 %, white 20 % rim, radius 24, padding 24; fields inside use the same
white 20 % rim), max width 420 (fixes the 0.1.6 full-width iPad dialog); `GlassTextField`s; `GlassButtonRow` Cancel +
primary, stacked at large text.

### Lobby (pre-join)

Local camera behind the veil (black with the initials avatar when off), the glass panel with room name, display
name, password when needed, mic and camera `MediaControlButton`s (toggle state + off icon, red 40 % tint when off)
and the primary Join.

### Call

Video full screen (1: local cover; 2: remote + draggable PiP; 3+: grid). Room name badge at the top (grows out of
the Dynamic Island on supported iPhones in portrait, else slides in: `DynamicIslandBadge`). Bottom row of round glass controls
(`MediaControlsRow`, 20 dp gaps, shrinking to never below 48 dp): mic, camera, flip (touch), speaker (phones),
hang up (`#FF453A` 40 %). Participants and Invite as glass circles in the top corners. Join/leave and state lines in
the 0.1.6 HUD glass (blur 12, white 10 % rim; black 70 % for notices, 80 % for state lines, 0.1.6 had 50 %),
announced as live regions. Auto-hide of the chrome stays off while a screen reader is on, while keyboard focus is
inside it, or when motion is reduced.

### Ended and errors

`GlassStatusScreen`: black with the glass dialog panel in the middle; "Call ended" with Rejoin and Home. Join and
lookup errors use the same frame with copy from §10, never raw exception text (0.1.6 showed it in red).

### Accessibility added to the 0.1.6 look

- Every glass circle and bounce button: accessible name, `toggled` for toggles, tooltip, 48 dp target, focus ring,
  Enter/Space; reduced motion removes bounce, stretch, morph and slides.
- `CustomTextField`: the 0.1.6 look at rest (`surface` fill, no visible rim), visible keyboard focus (2 dp `#00AEFF`,
  6.75:1 on the fill, only in `FocusHighlightMode.traditional`; touch keeps the 0.1.6 look), hint as the accessible
  name, verbatim passwords (QA D2).
- Destructive dialog buttons: `#FF453A` with black text (6.16:1; white would be 3.41:1).
- Glass on every platform: `GlassEffect` draws the FakeGlass look with `BackdropFilter` and canvas strokes, no
  shaders, so web (CanvasKit, skwasm) matches iOS and macOS.
- Known contrast debt kept for the look:
  [tokens.md, Known contrast debt](tokens.md#known-contrast-debt-kept-on-purpose-user-decision-pending).
