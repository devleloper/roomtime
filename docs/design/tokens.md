# Design tokens

Status: v1 · 2026-11-06 · Owner: maintainers
Source of truth for the look: the original dev-0.1.6 screens and widgets (dev-0.1.6 sources at `3b3c480`,
[flows.md §14](flows.md#14-dev-016-look-source-of-truth)). Tokens below name the values those widgets use.
Brand identity, logo and icon rules: [identity.md](identity.md).
Code: `lib/presentation/theme/` (`app_colors.dart`, `app_color_schemes.dart`, `app_theme.dart`,
`app_tokens.dart`, `app_typography.dart`), components in `lib/presentation/widgets/`. No barrel files: import
each file (`package:roomtime/presentation/theme/app_tokens.dart`).
Enforced by `test/presentation/widgets/theme_contrast_test.dart` and `typography_test.dart`.

## Rules

1. Colors come from `Theme.of(context).colorScheme`, `AppSemanticColors.of(context)` or the 0.1.6 `AppColors`
   constants; `AppPalette` is read only by the theme files and `InitialsAvatar`; no `Color(0x…)` outside the theme.
2. New code takes spacing, radius, sizes and durations from `AppSpacing`, `AppRadius`, `AppSizes`, `AppMotion`. The
   0.1.6 screens and glass widgets keep their original literal values (the look is frozen).
3. Every animation duration goes through `AppMotion.resolve(context, …)` or checks `AppMotion.reduced(context)`.
4. Layout reacts to width (`WindowSizeClass.of(context)` / `fromWidth`; Home keeps the 0.1.6 600 dp split).
   Platform-only controls use `lib/core/utils/platform.dart` (`isTouchPlatform`, `isMobilePlatform`,
   `isMacOSApp`). Hover, shortcuts and the focus ring follow the input actually used, never width.
5. Glass only through `GlassEffect` (via `LiquidGlassContainer`, `LiquidBounceButton`, `GlassSurface`, `GlassPanel`,
   `GlassHudPill`, `VideoVeil`). No shaders, no `liquid_glass_renderer`.
6. The app is dark-only, as in 0.1.6: `MaterialApp.router(theme: AppTheme.dark, themeMode: ThemeMode.dark)`.
   `AppTheme.dark` is the only theme; there is no light scheme in code.

## Color

M3 `ColorScheme` with every role set explicitly (no `fromSeed`), so the ratios below are exact. Brand palette
(identity.md): RoomTime Blue `#00AEFF`, the project's main color, is the primary and the icon color. On `#00AEFF` the
app keeps the 0.1.6 white label (known debt below; Ink `#001D2F` would pass). Secondary is a blue-tinted grey
("mist"); tertiary is the apricot family of Doorlight `#FFB164`, the complementary accent.

### Dark (the app theme): the dev-0.1.6 look

0.1.6 `ColorScheme.dark(primary: #00AEFF, surface: #1E1E1E, error: #FF453A)`, black scaffolds, white text, white
glass rims, in the platform system font (Inter on web). `AppColors` (0.1.6 API, `app_colors.dart`) maps to
the palette: primary `#00AEFF`, background `#121212`, surface `#1E1E1E`, textPrimary `#FFFFFF`, textSecondary
`#AAAAAA`, error `#FF453A`, success `#34C759`.

| Role | Hex | Pair | Ratio | Min |
| --- | --- | --- | --- | --- |
| surface | `#1E1E1E` | onSurface `#FFFFFF` | 16.67 | 4.5 |
| onSurfaceVariant | `#AAAAAA` | on surface | 7.18 | 4.5 |
| | | on surfaceContainerHighest `#333333` | 5.44 | 4.5 |
| primary | `#00AEFF` | on surface (text buttons, links) | 6.75 | 4.5 |
| | | on black | 8.50 | 4.5 |
| onPrimary | `#FFFFFF` | on primary (filled button, CTA) | **2.47** | 4.5 (debt) |
| error | `#FF453A` | on surface (error text) | 4.89 | 4.5 |
| | | on black | 6.16 | 4.5 |
| onError | `#000000` | on error | 6.16 | 4.5 |
| errorContainer / on | `#93000A` / `#FFDAD6` | | 7.24 | 4.5 |
| inverseSurface / on | `#E6E6E6` / `#1E1E1E` | | 13.36 | 4.5 |
| outline | `#8A8A8A` | on surface | 4.83 | 3.0 |

Surface containers: lowest `#000000`, low `#121212`, container `#1E1E1E`, high `#282828`, highest `#333333`.
`inversePrimary` is Blue 40 `#006A9E`. Outlined field rims (`AppGlass.fieldBorderAlpha`), outlined buttons, dialog
and sheet rims: white 20 %; snackbar and tooltip rims: white 15 %; dividers white 10 %. Field label white 70 %,
focused border `#00AEFF`.

#### Known contrast debt (kept on purpose, user decision pending)

- White labels on `#00AEFF` (Create Room, Join, dialog primary `GlassDialogButton`): 2.47:1, below WCAG 1.4.3.
  One-token fix: `AppColorSchemes.dark.onPrimary` and the `GlassDialogButton` primary label to Ink `#001D2F`
  (6.98:1; Ink is not in `AppPalette` yet). Pinned in `theme_contrast_test.dart`.
- Panel, dialog and outlined field rims are the 0.1.6 white 20 % hairline: 1.66:1 on black, below WCAG 1.4.11 for the
  fields. One-token fix: `AppGlass.fieldBorderAlpha = 0.45` (4.41:1). `CustomTextField` has no visible rim at rest, as
  in 0.1.6; its hint and the `#1E1E1E` fill identify it. Pinned in `theme_contrast_test.dart`.
- 0.1.6 glass circles tinted `#FF453A` 40 % or `surface` 40 % (`LiquidBounceButton`) over a bright frame: the
  multiplied tint stays light, white icons can fall under 3:1 (the HUD lines use black 70-80 % for this reason).

### Semantic extension (`AppSemanticColors`)

Defined once, `AppSemanticColors.dark`.

| Role | Value | Pair | Ratio |
| --- | --- | --- | --- |
| danger / onDanger (defined; destructive dialog buttons use `#FF453A` with black text, 6.16) | `#C62828` / `#FFFFFF` | | 5.62 |
| warningContainer / on (defined; reconnecting is a HUD line) | `#4A3800` / `#FFDF9E` | | 8.78 |
| focusRing | `#00AEFF` | on surface | 6.75 (on surfaceContainerHigh 5.97) |
| videoGlass (soft white, defined; the pressed glare uses `AppGlass.pressedGlareAlpha`) | white 20 % | — | — |
| videoScrim / onVideoScrim | black 60 % / `#FFFFFF` | white text over a pure white frame | 5.74 |

Over video, text sits on at least `videoScrim` (tile name pills, the Home veil, `GlassSurface(variant: overlay)` for
the room pill, which enforces the same minimum) or on the darker HUD glass: notices black 70 % (`GlassHudPill`, white
text 8.45:1 on a white frame), state lines black 80 % (`CallBannerNotice`, 12.63:1). On `videoScrim` white text is
21:1 over a black frame and 10.16:1 over RoomTime Blue. The call controls are 0.1.6 tinted glass with no guaranteed
ratio over bright frames (Known contrast debt).

Theme pairs pinned by `theme_contrast_test.dart`, not drawn by the 0.1.6 call controls: neutral `#FFFFFF` on
`#333333` 12.63:1; inverse `#1E1E1E` on `#E6E6E6` 13.36:1; danger `#FFFFFF` on `#C62828` 5.62:1.

Avatar backgrounds (`AppPalette.avatar`, white initials): `#1E6091` 6.69, `#6A4C93` 6.85, `#2D6A4F` 6.39, `#9C4221`
6.53, `#8E3B5B` 7.18, `#4A5568` 7.53, `#00687A` 6.44, `#7C5E10` 6.06. The color is picked from the participant
identity with a stable hash, so it is the same on every client.

Color is never the only signal: muted mic shows `mic_off` and says "microphone off" in semantics; the active speaker
gets a border **and** a speaking icon; errors have an icon and text.

## Typography

Native (iOS, macOS, Android, desktop): the platform system font, as in dev-0.1.6 (SF Pro / Roboto):
`AppTypography.fontFamily` is `null` and `ThemeData`'s platform `Typography` supplies the family (VIS-01, 2026-11-04).
Web: Inter 4.1 variable (bundled, SIL OFL 1.1, `assets/fonts/inter/`); no font is fetched at runtime (no
fonts.gstatic.com, CSP `font-src 'self'`). `AppTypography.textThemeFor(web:)`
(`lib/presentation/theme/app_typography.dart`) builds both; `typography_test.dart` checks the family per
platform. `FontWeight` drives Inter's `wght` axis directly, so code uses `fontWeight` as usual, never
`fontVariations`.

M3 sizes, line heights and weights are the same on every platform. Tracking: native keeps only the 0.1.6 tracking
(-0.5 on the 34/28 hero titles; system fonts carry their own optical tracking); web uses Inter's dynamic tracking
(dynamic tracking `-0.0223 + 0.185·e^(-0.1745·size)` em). Sizes in sp, scaled by the user's text size; the screen
tests, `components_test.dart` and `glass_test.dart` run at 200 %.

The scale below is the theme `TextTheme` (Material widgets: snackbars, tooltips, list tiles, the room pill, tile
names). The 0.1.6 screens and glass widgets set their original sizes on top of the theme family: Home title 34 / 28
bold, glass dialog title 24 bold, CTA and dialog buttons 16–17 w600, dialog text 15, Home section labels 13 w600
white 90 %.

| Style | Size / line | Weight | Tracking (px) | Use |
| --- | --- | --- | --- | --- |
| displayLarge | 57 / 64 | 700 | -1.25 | (defined, unused) |
| displayMedium | 45 / 52 | 700 | -1.0 | |
| displaySmall | 36 / 44 | 700 | -0.8 | |
| headlineLarge | 34 / 41 | 700 | -0.5 (native too) | = 0.1.6 Home title, phone |
| headlineMedium | 28 / 34 | 700 | -0.5 (native too) | = 0.1.6 Home title, sidebar |
| headlineSmall | 24 / 32 | 600 | -0.45 | Material dialog titles |
| titleLarge | 22 / 28 | 600 | -0.4 | App bar titles |
| titleMedium | 16 / 24 | 600 | -0.15 | Material buttons, room pill, list tiles |
| titleSmall | 14 / 20 | 600 | -0.1 | Section headers |
| bodyLarge | 16 / 24 | 400 | -0.15 | Body, field input, labels and hints |
| bodyMedium | 14 / 20 | 400 | -0.1 | Secondary text, dialog content, snackbars |
| bodySmall | 12 / 16 | 400 | 0 | Helper and error text, tooltips |
| labelLarge | 14 / 20 | 600 | -0.1 | Material label default |
| labelMedium | 12 / 16 | 600 | 0 | Tile name labels |
| labelSmall | 11 / 16 | 600 | +0.05 | Badges only (never body copy) |

Tracking column: web (Inter); native uses 0 except the two hero titles.

All styles use `TextLeadingDistribution.even` so single-line labels sit optically centred in buttons and chips.
Colors are not part of the styles: `ThemeData` merges them from the scheme (`onSurface`).

## Spacing, shape, elevation, sizes

| Token | Values (dp) |
| --- | --- |
| `AppSpacing` | xxs 2 · xs 4 · sm 8 · md 12 · lg 16 · xl 24 · xxl 32 · xxxl 48 |
| `AppRadius` | xs 4 · sm 8 (tooltips) · md 12 (buttons, fields, list rows) · lg 16 (`CustomTextField`, `LiquidGlassContainer` default, snackbars) · xl 24 (`GlassSurface` default, Material dialogs, sheets) · xxl 28 · full (focus ring default); `*All` `BorderRadius` constants |
| `AppElevation` | level0 0 · level1 1 · level2 3 · level3 6 · level4 8 · level5 12 |
| `AppSizes` | minTarget 48 · iconSm 20 / icon 24 / iconLg 28 / iconXl 48 · avatar 40 (tile 32–120) · focusRingWidth 3 + focusRingGap 2 · fieldBorderWidth 2 (`CustomTextField` focused border) · dialogMaxWidth 560 (bottom sheets) |

Targets: every interactive element is at least 48×48 dp on every platform (covers the iOS 44 pt guideline;
`MinTapTarget` in `custom_bounce_button.dart` pads the bounce buttons). The theme forces `VisualDensity.standard` and
`MaterialTapTargetSize.padded`, because desktop defaults shrink buttons to 40 dp.

## Motion

| Token | Value | Use |
| --- | --- | --- |
| `AppMotion.fast` | 100 ms | (defined) |
| `AppMotion.short` | 200 ms | Small fades (tile speaking glow and border) |
| `AppMotion.medium` | 300 ms | Sheet content, notices, PiP/main swap crossfade, create-dialog step change |
| `AppMotion.long` | 500 ms | Tooltip wait, Home camera crossfade from black, camera flip |
| `AppMotion.standard` / `enter` / `exit` | M3 `Easing.standard` / `emphasizedDecelerate` / `emphasizedAccelerate` | |
| `AppMotion.pressedScale` | 0.94 | `AppPressable` default shrink |
| `AppMotion.bounceScale` / `bounceScaleSmall` | 1.15 / 1.08 | 0.1.6 bounce: glass circles / pill buttons. In `pressIn` 150 ms `pressInCurve` easeOut, back `pressRelease` 300 ms `pressReleaseCurve` easeOutBack |
| `AppMotion.glare` / `glareCurve` | 150 ms easeInOut | Pressed white glare |
| `AppMotion.stretchScale` / `stretchFactor` / `stretchResistance` / `stretchIn` / `stretchSettle` | 1.05 / 0.2 / 0.08 / 300 ms / 500 ms easeOutBack | `LiquidBounceButton` drag stretch |
| `AppMotion.islandMorph` | 650 ms easeOutQuint | Room pill out of / into the Dynamic Island |
| `AppMotion.pillIn` / `pillOut` | 400 / 300 ms, `chromeCurve` easeOutCubic | Room pill fallback: slide 1.5x height + fade |
| `AppMotion.chromeAutoHide` | 4 s | Call controls + pill auto-hide (never while a screen reader or keyboard focus is in the chrome); the hide itself is 300 ms easeOutCubic in `CallView` |
| `AppMotion.pipSnap` | 300 ms | PiP snaps to the nearest side |
| `AppMotion.gridReflow` | 650 ms `gridReflowCurve` `Curves.elasticOut` | Grid tiles on join/leave |

Reduced motion (`MediaQuery.disableAnimations`: iOS Reduce Motion, Android Remove animations, macOS Reduce motion):
`AppMotion.resolve` returns zero, `AppPressable` drops the press scale, and tile reflow, camera flip, PiP snap, island
morph, chrome fade and notices are instant. Progress indicators keep spinning (essential status). Nothing flashes more
than 3 times per second.

## Glass (dev-0.1.6 FakeGlass look, no shaders)

`GlassEffect` draws what `liquid_glass_renderer` 0.2.0-dev.4 `FakeGlass` drew on iOS/macOS in 0.1.6, from Flutter
primitives only: `BackdropFilter` with saturation 1.5 then blur (mirror edges), the tint multiplied in (screen for
light tints), and a specular rim (1.5 dp hard-light + 2 dp soft overlay stroke, gradient along the light angle 90°:
top and bottom edges bright, sides clear), then the child. Same on iOS, Android, macOS and web (CanvasKit, skwasm).
The package itself is not used: 0.2.0-dev.4 declares shaders that break `flutter build web`; 1.0.0-dev.2 builds for
web but draws a different FakeGlass (contour, bevel, shader surface on Impeller only) and pins Dart `<3.14`.
Model credit: liquid_glass_renderer (MIT, Copyright 2025 Tim Lehmann for whynotmake.it); independent implementation,
no code copied.

Original 0.1.6 classes (same names and constructors): `LiquidGlassContainer` (`glass_surface.dart`; sigma = blur x 2,
default tint `surface` 40 %, `borderColor: Colors.transparent` = no rim), `LiquidBounceButton`, `CustomBounceButton`,
`CustomTextField`. The 0.1.6 `CustomCard` had no call site and is not part of the kit. `GlassSurface`,
`GlassPanel` (dialogs, lobby), `GlassHudPill`, `VideoVeil` and `DynamicIslandBadge` use the same material.

| Token | Value | Use |
| --- | --- | --- |
| `AppGlass.blurFactor` / `containerBlur` | 2 / 12 | `LiquidGlassContainer` sigma = blur x 2 (0.1.6 FakeGlass blur 12) |
| `AppGlass.blurSigma` | 24 | `GlassEffect`, `GlassSurface` default (pills, circles) |
| `AppGlass.veilBlurSigma` | 60 | `VideoVeil` (0.1.6: blur 30 x 2); `GlassPanel` uses the same blur 30 |
| `AppGlass.saturation`, `lightAngle`, `lightIntensity`, `thickness` | 1.5, π/2, 0.5, 20 | FakeGlass defaults |
| `AppGlass.containerTintAlpha` / `dialogTintAlpha` | 0.4 / 0.5 | `LiquidGlassContainer` default / `GlassPanel` default (glass dialogs, status screens) |
| `GlassPanel.overVideoTintAlpha` | 0.75 | Lobby panel and the alone card over live video |
| `VideoVeil.tintAlpha` | black 0.6 | Home veil: white text 5.74:1 on a white frame |
| `callHudTintAlpha` (`glass_surface.dart`) | black 0.7 | `GlassHudPill`: join/leave and copied pills; state lines are black 0.8 |
| `AppGlass.overlayMinAlpha` / `overlayFallbackMinAlpha` | 0.6 / 0.8 | `GlassSurface(overlay)` with / without blur |
| `AppGlass.panelMinAlpha` / `fallbackMinAlpha` | 0.72 / 0.94 | `GlassSurface(panel)` with / without blur (high contrast drops the blur) |
| `AppGlass.borderAlpha` / `dialogBorderAlpha` / `subtleBorderAlpha` | 0.15 / 0.20 / 0.10 | 0.1.6 rims (theme: snackbars, tooltips, sheets / outlined buttons, dialogs / dividers) |
| `AppGlass.fieldBorderAlpha` | 0.20 | outlined field resting rim, as in 0.1.6 (1.66:1 on black, known debt) |
| `AppGlass.pressedGlareAlpha` | 0.20 | White glare on press |
| `AppGlass.secondaryFillAlpha` | 0.10 | Secondary dialog button fill (Cancel) |
| `AppGlass.labelAlpha` | 0.70 | Field labels and field icons (theme) |

Press physics (`AppMotion`): bounce 1.15 (glass circles) / 1.08 (`CustomBounceButton`), in 150 ms easeOut, back
300 ms easeOutBack; glare fades 150 ms easeInOut; `LiquidBounceButton` also grows x1.05 while touched and stretches
0.2 x the resisted drag (resistance 0.08), settling 500 ms easeOutBack. Press starts on pointer down
(`AppPressable` uses a `Listener`). Reduced motion: no scale, stretch or crossfade.

Tones over video (0.1.6): controls are `LiquidBounceButton`s tinted `surface` 40 %; device off and hang-up are
tinted `#FF453A` 40 % (debt above). Primary CTA = `#00AEFF` with a white label as in 0.1.6 (2.47:1, known debt above).

Sizes (`AppSizes`): `glassControl` 60 (the call row shrinks it to 48 when space is short; the Home sidebar circle is
28 inside a 48 target), `glassPillHeight` 44, `dynamicIsland` 125 x 37 at `dynamicIslandTop` 11, `sidebarWidth` 380,
`pip` 120 x 160, `glassDialogMaxWidth` 420.

Theme: the app is dark-only (`theme: AppTheme.dark, themeMode: ThemeMode.dark`); scaffolds are black.

## Window size classes

| Class | Width (dp) | Typical |
| --- | --- | --- |
| compact | < 600 | phones portrait |
| medium | 600–839 | tablets portrait, foldables, narrow desktop windows |
| expanded | 840–1199 | tablets landscape, desktop |
| large | 1200–1599 | desktop |
| extraLarge | ≥ 1600 | large monitors |

## Focus and state

- Focus ring: 3 dp `focusRing` color, 2 dp gap outside the control (`FocusRing`), shown only while the user navigates
  with a keyboard (`FocusHighlightMode.traditional`). Contrast ≥ 3:1 against the surrounding surface (WCAG 2.4.7,
  1.4.11).
- Text fields show focus by their border: `CustomTextField` gets a 2 dp `#00AEFF` border with keyboard focus only (no
  rim at rest, as in 0.1.6); dialog fields (`GlassTextField`, theme `inputDecorationTheme`) white 20 % → `#00AEFF`, as
  in 0.1.6.
- State layers: Material defaults of the theme (no project tokens).

## Shared widgets

The screens are built on the original 0.1.6 widgets. Accessibility they carry without a visual change:

| Class | Name / state | Keyboard | Target | Reduced motion |
| --- | --- | --- | --- | --- |
| `LiquidBounceButton` | `semanticLabel` (pass it localized; English fallback from the 0.1.6 icons), `toggled`, `tooltip` | focus ring, Enter/Space/Select/A | ≥ 48 dp (28 dp circle padded) | no bounce, stretch, crossfade |
| `CustomBounceButton` | text inside `child`, or `semanticLabel`; `toggled` | same | ≥ 48 dp (`MinTapTarget`) | no bounce |
| `CustomTextField` | `hintText` is the name | focus border; `onSubmitted` + `textInputAction` (Enter joins), `focusNode`, `autofocus`, `inputFormatters` (all optional, defaults as 0.1.6) | field height ≥ 48 | — |
| `LiquidGlassContainer` | visual only | — | — | — |

Text fields (QA): secret inputs (`CustomTextField(isPassword: true)`, `GlassTextField(obscure: true)`) disable
autocorrect, suggestions, capitalization and smart dashes/quotes, hidden or shown (D2). After a wrong password, clear
instead of selecting (D4): `controller.clear()`.

All shared widgets, by file in `lib/presentation/widgets/`:

| File | Public API |
| --- | --- |
| `liquid_bounce_button.dart`, `custom_bounce_button.dart`, `custom_text_field.dart` | the 0.1.6 classes above; `MinTapTarget` |
| `glass_effect.dart`, `glass_surface.dart` | `GlassEffect`; `GlassSurface` (`GlassVariant`), `LiquidGlassContainer`, `GlassPanel`, `GlassHudPill`, `VideoVeil` |
| `glass_dialog.dart` | `showGlassDialog`, `showGlassConfirm`, `showGlassChoices` (`GlassChoice`), `GlassDialogContent`, `GlassDialogTitle`, `GlassDialogText`, `GlassErrorText`, `GlassStatusScreen` |
| `glass_button.dart`, `glass_text_field.dart` | `GlassDialogButton` (`GlassButtonStyle`), `GlassButtonRow`; `GlassTextField` |
| `invite_panel.dart`, `invite_sharing.dart` | `InvitePanel`; `copyWithConfirmation`, `shareInvite`, `shareFinished`, `spokenRoomCode` |
| `participant_video.dart`, `initials_avatar.dart` | `ParticipantVideo`; `InitialsAvatar`, `AvatarTilePlaceholder` |
| `app_pressable.dart`, `focus_ring.dart` | internals `AppPressable`, `FocusRing` |

Feature-level pieces stay in `features/`: `HomeMobileLayout`, `HomeDesktopLayout`, `JoinWithCodeField`
(`features/home/widgets/`); `MediaControlButton` / `MediaControlsRow`, `CallControlBar`, `CallTopBar`, `CallBanners`,
`LobbyDeviceNotices` (`features/room/widgets/`).

Tests in `test/presentation/widgets/`: `controls_test.dart` (bounce buttons, `LiquidGlassContainer`, text
fields), `components_test.dart` (tokens, `GlassSurface`, `InitialsAvatar`), `glass_test.dart`
(`DynamicIslandBadge`, glass on every platform), `glass_button_row_test.dart`, `invite_sharing_test.dart`,
`theme_contrast_test.dart`, `typography_test.dart`.

Preview: `img/original-widgets.png` is a static capture of the 0.1.6 widgets (Home, call, Create dialog and the
removed `CustomCard` in the last panel); no test regenerates it.

## Assets and licenses

- Inter 4.1 variable: SIL OFL 1.1, `assets/fonts/inter/OFL.txt`.
- RoomTime logo, app icons, splash and favicons: original work for this project (2026), built from
  `assets/brand/src/roomtime-mark.svg`; the wordmark is Inter Bold converted to outlines (artwork made with an
  OFL font is not subject to the OFL). Details: [identity.md](identity.md#assets-and-licenses).
- The former FamilyCalls `assets/brand/logo.png` (the author's own work) was retired with the rename.
- Icons: Material Icons font (Apache-2.0, bundled by `uses-material-design: true`).
- `assets/sounds/*.m4a`: original join/leave chimes synthesised by `assets/sounds/tool/make_sounds.py`
  (AGPL-3.0-only, see NOTICE).
