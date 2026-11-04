# Design tokens

Status: v1 · 2026-11-04 · Owner: ux-ui-designer
Source of truth for the look: the original dev-0.1.6 screens and widgets (dev-0.1.6 sources at `3b3c480`,
[flows.md §14](flows.md#14-dev-016-look-source-of-truth)). Tokens below name the values those widgets use.
Brand identity, logo and icon rules: [identity.md](identity.md).
Code: `lib/presentation/theme/` (import `theme/theme.dart`), components in
`lib/presentation/widgets/` (import `widgets/widgets.dart`).
Enforced by `test/presentation/widgets/theme_contrast_test.dart`.

## Rules

1. Screens read colors from `Theme.of(context).colorScheme` and `AppSemanticColors.of(context)`, never from
   `AppPalette` and never as `Color(0x…)` literals.
2. Spacing, radius, sizes and durations come from `AppSpacing`, `AppRadius`, `AppSizes`, `AppMotion`. A justified
   one-off literal carries a comment.
3. Every animation duration goes through `AppMotion.resolve(context, …)` or checks `AppMotion.reduced(context)`.
4. Layout decisions use `WindowSizeClass.of(context)`. Input decisions (hover, shortcuts, focus model) are made from
   the input actually used, never from width.
5. Glass only through `GlassEffect` (via `LiquidGlassContainer`, `LiquidBounceButton`, `GlassSurface`). No shaders,
   no `liquid_glass_renderer`.
6. The app is dark-only, as in 0.1.6: `MaterialApp(theme: AppTheme.dark, themeMode: ThemeMode.dark)`, and the call
   view wraps itself in `AppTheme.dark` too. `AppTheme.darkTheme` is the 0.1.6 name of `dark`. `AppTheme.light`
   exists for tests and a later light mode; no screen uses it.

## Color

M3 `ColorScheme` with every role set explicitly (no `fromSeed`), so the ratios below are exact. Brand palette
(identity.md): RoomTime Blue `#00AEFF`, the project's main color, is the dark-theme primary and the icon color. It is
too light for text on light surfaces (2.35:1 on Paper) and under white text (2.47:1), so the light theme uses Blue 40
`#006A9E` (same OKLCH hue 240) as primary. On `#00AEFF` the dark theme keeps the 0.1.6 white label (known debt
below; Ink `#001D2F` would pass). Secondary is a blue-tinted grey ("mist"); tertiary is the apricot family of
Doorlight `#FFB164`, the complementary accent.

### Dark (the app theme): the dev-0.1.6 look

0.1.6 `ColorScheme.dark(primary: #00AEFF, surface: #1E1E1E, error: #FF453A)`, black scaffolds, white text, white
glass rims, in the platform system font (Inter on web). `AppColors` (0.1.6 API) maps to
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
Outlined field rims (`AppGlass.fieldBorderAlpha`), outlined buttons, dialog and sheet rims: white 20 %; snackbar
and tooltip rims: white 15 %; dividers white 10 %. Field label white 70 %, focused border `#00AEFF`.

#### Known contrast debt (kept on purpose, user decision pending)

- White labels on `#00AEFF` (Create Room, Join, dialog primary `GlassDialogButton`): 2.47:1, below WCAG 1.4.3.
  One-token fix: `AppColorSchemes.dark.onPrimary = AppPalette.ink` (6.98:1). Pinned in `theme_contrast_test.dart`.
- Panel, dialog and outlined field rims are the 0.1.6 white 20 % hairline: 1.66:1 on black, below WCAG 1.4.11 for the
  fields. One-token fix: `AppGlass.fieldBorderAlpha = 0.45` (4.41:1). `CustomTextField` has no visible rim at rest, as
  in 0.1.6; its label or hint and the `#1E1E1E` fill identify it. Pinned in `theme_contrast_test.dart`.
- 0.1.6 glass circles tinted `#FF453A` 40 % or `surface` 40 % (`LiquidBounceButton`) over a bright frame: the
  multiplied tint stays light, white icons can fall under 3:1 (the HUD lines use black 70-80 % for this reason).

### Light (defined, not used by any screen yet)

| Role | Hex | Pair | Ratio | Min |
| --- | --- | --- | --- | --- |
| surface | `#F9F9FB` | onSurface `#1A1C1E` | 16.25 | 4.5 |
| onSurfaceVariant | `#42474E` | on surface | 8.90 | 4.5 |
| | | on surfaceContainerHighest `#E1E2E4` | 7.22 | 4.5 |
| primary | `#006A9E` | on surface | 5.62 | 4.5 |
| | | on surfaceContainerHigh `#E7E8EA` | 4.82 | 4.5 |
| onPrimary | `#FFFFFF` | on primary | 5.91 | 4.5 |
| primaryContainer / on | `#CCE9FF` / `#001D2F` | | 13.70 | 4.5 |
| secondary / on | `#4C5D6A` / `#FFFFFF` | | 6.82 | 4.5 |
| secondaryContainer / on | `#D4E8F7` / `#05131D` | | 14.93 | 4.5 |
| tertiary / on | `#9B540C` / `#FFFFFF` | | 5.73 | 4.5 |
| tertiaryContainer / on | `#FEDFBE` / `#361900` | | 12.74 | 4.5 |
| error | `#BA1A1A` | on surface | 6.14 | 4.5 |
| onError | `#FFFFFF` | on error | 6.46 | 4.5 |
| errorContainer / on | `#FFDAD6` / `#410002` | | 13.26 | 4.5 |
| inverseSurface / on | `#2F3033` / `#F1F0F4` | | 11.63 | 4.5 |
| inversePrimary | `#00AEFF` | on inverseSurface | 5.34 | 4.5 |
| outline | `#72777F` | on surface | 4.29 | 3.0 |
| | | on surfaceContainerHigh `#E7E8EA` | 3.68 | 3.0 |

### Semantic extension (`AppSemanticColors`)

| Role | Dark | Light | Pair | Ratio |
| --- | --- | --- | --- | --- |
| danger / onDanger (defined; destructive dialog buttons use `#FF453A` with black text, 6.16) | `#C62828` / `#FFFFFF` | same | | 5.62 |
| warningContainer / on (defined; reconnecting is a HUD line) | `#4A3800` / `#FFDF9E` | `#FFDF9E` / `#261A00` | | 8.78 / 13.25 |
| focusRing | `#00AEFF` | `#006A9E` | on surface | 6.75 / 5.62 (on surfaceContainerHigh 5.97 / 4.82) |
| videoGlass (soft white, defined; the pressed glare uses `AppGlass.pressedGlareAlpha`) | white 20 % | same | — | — |
| videoScrim / onVideoScrim | black 60 % / `#FFFFFF` | same | white text over a pure white frame | 5.74 |

Over video, text sits on at least `videoScrim` (tile name pills, the Home veil, `GlassSurface(variant: overlay)` for
the room pill, which enforces the same minimum) or on the darker HUD glass: notices black 70 % (white text 8.45:1 on
a white frame), state lines black 80 % (12.63:1). On `videoScrim` white text is 21:1 over a black frame and 10.16:1
over RoomTime Blue. The call controls are 0.1.6 tinted glass with no guaranteed ratio over bright frames (Known
contrast debt).

Theme pairs pinned by `theme_contrast_test.dart`, not drawn by the 0.1.6 call controls: neutral `#FFFFFF` on
`#333333` 12.63:1; inverse `#1E1E1E` on `#E6E6E6` 13.36:1; danger `#FFFFFF` on `#C62828` 5.62:1.

Avatar backgrounds (white initials): `#1E6091` 6.69, `#6A4C93` 6.85, `#2D6A4F` 6.39, `#9C4221` 6.53,
`#8E3B5B` 7.18, `#4A5568` 7.53, `#00687A` 6.44, `#7C5E10` 6.06. The color is picked from the participant identity
with a stable hash, so it is the same on every client.

Color is never the only signal: muted mic shows `mic_off` and says "microphone off" in semantics; the active speaker
gets a border **and** a speaking icon; errors have an icon and text.

## Typography

Native (iOS, macOS, Android, desktop): the platform system font, as in dev-0.1.6 (SF Pro / Roboto):
`AppTypography.fontFamily` is `null` and `ThemeData`'s platform `Typography` supplies the family (VIS-01, 2026-11-04).
Web: Inter 4.1 variable (bundled, SIL OFL 1.1, `assets/fonts/inter/`); no font is fetched at runtime (no
fonts.gstatic.com, CSP `font-src 'self'`). The RoomTime wordmark (`RoomTimeLogo`) is Inter everywhere.
`AppTypography.textThemeFor(web:)` (`lib/presentation/theme/app_typography.dart`) builds both. `FontWeight`
drives Inter's `wght` axis directly, so screens use `fontWeight` as usual, never `fontVariations`.

M3 sizes, line heights and weights are the same on every platform. Tracking: native keeps only the 0.1.6 tracking
(-0.5 on the 34/28 hero titles; system fonts carry their own optical tracking); web uses Inter's dynamic tracking
(dynamic tracking `-0.0223 + 0.185·e^(-0.1745·size)` em). Sizes in sp, scaled by the user's text size; every component
is tested at 200 %.

| Style | Size / line | Weight | Tracking (px) | Use |
| --- | --- | --- | --- | --- |
| displayLarge | 57 / 64 | 700 | -1.25 | Marketing, empty hero (rare) |
| displayMedium | 45 / 52 | 700 | -1.0 | |
| displaySmall | 36 / 44 | 700 | -0.8 | |
| headlineLarge | 34 / 41 | 700 | -0.5 (native too) | Home title, phone (0.1.6) |
| headlineMedium | 28 / 34 | 700 | -0.5 (native too) | Home title, sidebar (0.1.6) |
| headlineSmall | 24 / 32 | 600 | -0.45 | Material dialog titles |
| titleLarge | 22 / 28 | 600 | -0.4 | App bar titles |
| titleMedium | 16 / 24 | 600 | -0.15 | Buttons (0.1.6 16 w600), room pill, list tiles |
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
| `AppSpacing` | xxs 2 · xs 4 · sm 8 · md 12 · lg 16 · xl 24 · xxl 32 · xxxl 48 · card 20 (`CustomCard`, `CustomTextField`) |
| `AppRadius` | xs 4 · sm 8 (tooltips) · md 12 (buttons, dialog fields, list rows) · lg 16 (`CustomTextField`, snackbars) · xl 24 (`CustomCard`, dialogs, sheets) · xxl 28 · full (pills, name tags, focus ring default) |
| `AppElevation` | level0 0 · level1 1 · level2 3 · level3 6 · level4 8 · level5 12 |
| `AppSizes` | minTarget 48 · icon 20/24/28/48 · avatar 40 (tile 32–120) · focusRing 3 wide + 2 gap · fieldBorderWidth 2 (`CustomTextField` focused border) · dialogMaxWidth 560 (Material dialogs) |

Targets: every interactive element is at least 48×48 dp on every platform (covers the iOS 44 pt guideline). The
theme forces `VisualDensity.standard` and `MaterialTapTargetSize.padded`, because desktop defaults shrink buttons to
40 dp.

## Motion

| Token | Value | Use |
| --- | --- | --- |
| `AppMotion.fast` | 100 ms | Press feedback, hover |
| `AppMotion.short` | 200 ms | Controls bar show/hide, small fades |
| `AppMotion.medium` | 300 ms | Tile reflow, sheet content |
| `AppMotion.long` | 500 ms | Tooltip wait, page-level transitions |
| `AppMotion.standard` / `enter` / `exit` | M3 `Easing.standard` / `emphasizedDecelerate` / `emphasizedAccelerate` | |
| `AppMotion.pressedScale` | 0.94 | Custom pressables (shrink) |
| `AppMotion.bounceScale` / `bounceScaleSmall` | 1.15 / 1.08 | 0.1.6 bounce: glass circles / pill buttons. In `pressIn` 150 ms easeOut, back `pressRelease` 300 ms easeOutBack (all `AppPressable`s) |
| `AppMotion.islandMorph` | 650 ms easeOutQuint | Room pill out of / into the Dynamic Island |
| `AppMotion.pillIn` / `pillOut` | 400 / 300 ms, `chromeCurve` easeOutCubic | Room pill fallback: slide 1.5x height + fade |
| `AppMotion.chromeAutoHide` / `chromeHide` | 4 s / 300 ms easeOutCubic | Call controls + pill auto-hide (never while a screen reader or keyboard focus is in the chrome) |
| `AppMotion.pipSnap` / `pipSwap` | 300 ms easeOutCubic / 400 ms | PiP snaps to the nearest side; tap swaps PiP and main (fade + scale 0.95 to 1) |
| `AppMotion.gridReflow` | 650 ms `Curves.elasticOut` | Grid tiles on join/leave |
| `AppMotion.cameraFlip` | 600 ms easeInOut | 3D flip of the local preview on camera switch |
| `AppMotion.cameraStartDelay` / `cameraFadeIn` | 350 / 500 ms | Home camera starts after the route transition, crossfades from black |

Reduced motion (`MediaQuery.disableAnimations`: iOS Reduce Motion, Android Remove animations, macOS Reduce motion):
`AppMotion.resolve` returns zero, `AppPressable` drops the press scale, and screens must make tile reflow, camera
flip, PiP snap, controls fade and page transitions instant. Progress indicators keep spinning (essential status).
Nothing flashes more than 3 times per second.

## Glass (dev-0.1.6 FakeGlass look, no shaders)

`GlassEffect` draws what `liquid_glass_renderer` 0.2.0-dev.4 `FakeGlass` drew on iOS/macOS in 0.1.6, from Flutter
primitives only: `BackdropFilter` with saturation 1.5 then blur (mirror edges), the tint multiplied in (screen for
light tints), and a specular rim (1.5 dp hard-light + 2 dp soft overlay stroke, gradient along the light angle 90°:
top and bottom edges bright, sides clear), then the child. Same on iOS, Android, macOS and web (CanvasKit, skwasm).
The package itself is not used: 0.2.0-dev.4 declares shaders that break `flutter build web`; 1.0.0-dev.2 builds for
web but draws a different FakeGlass (contour, bevel, shader surface on Impeller only) and pins Dart `<3.14`.
Model credit: liquid_glass_renderer (MIT, Copyright 2025 Tim Lehmann for whynotmake.it); independent implementation,
no code copied.

Original 0.1.6 classes (same names and constructors): `LiquidGlassContainer` (sigma = blur x 2, default tint
`surface` 40 %, `borderColor: Colors.transparent` = no rim), `LiquidBounceButton`, `CustomBounceButton`,
`CustomCard`, `CustomTextField`. `GlassSurface`, `DynamicIslandBadge`, the Home veil and the glass dialogs use the same material.

| Token | Value | Use |
| --- | --- | --- |
| `AppGlass.blurSigma` | 24 | Pills, panels, circles (0.1.6: FakeGlass 12 x 2) |
| `AppGlass.veilBlurSigma` | 60 | Home veil, dialogs, sheets (0.1.6: blur 30 x 2) |
| `AppGlass.saturation`, `lightAngle`, `lightIntensity`, `thickness` | 1.5, π/2, 0.5, 20 | FakeGlass defaults |
| `AppGlass.containerTintAlpha` / `dialogTintAlpha` / `veilTintAlpha` | 0.4 / 0.5 / 0.5 | 0.1.6 tints |
| `AppGlass.overlayMinAlpha` / `videoScrim` | black 60 % | `GlassSurface(overlay)`, Home veil: white text 5.74:1 on a white frame |
| `AppGlass.panelMinAlpha` | 0.72 | `GlassSurface(panel)` |
| fallback (high contrast) | panel 0.94, overlay 0.80, no blur | `GlassSurface` |
| `AppGlass.borderAlpha` / `dialogBorderAlpha` / `subtleBorderAlpha` | 0.15 / 0.20 / 0.10 | 0.1.6 rims |
| `AppGlass.fieldBorderAlpha` | 0.20 | outlined field resting rim, as in 0.1.6 (1.66:1 on black, known debt) |
| `AppGlass.pressedGlareAlpha` | 0.20 | White glare on press |
| `AppGlass.secondaryFillAlpha` | 0.10 | Secondary dialog button fill (Cancel) |
| `AppGlass.labelAlpha` | 0.70 | Field labels, section labels |

Press physics (`AppMotion`): bounce 1.15 (glass circles) / 1.08 (`CustomBounceButton`), in 150 ms easeOut, back
300 ms easeOutBack; glare fades 150 ms easeInOut; `LiquidBounceButton` also grows x1.05 while touched and stretches
0.2 x the resisted drag (resistance 0.08), settling 500 ms easeOutBack. Press starts on pointer down
(`AppPressable` uses a `Listener`). Reduced motion: no scale, stretch or crossfade.

Tones over video (0.1.6): controls are `LiquidBounceButton`s tinted `surface` 40 %; device off and hang-up are
tinted `#FF453A` 40 % (debt above). Primary CTA = `#00AEFF` with a white label as in 0.1.6 (2.47:1, known debt above).

Sizes: `glassControl` 60, `glassControlSmall` 28 (target stays 48), `glassPillHeight` 44, `dynamicIsland`
125 x 37 at top 11, `sidebarWidth` 380, `pip` 120 x 160, `glassDialogMaxWidth` 420.

Theme: the app is dark-only (`theme: AppTheme.dark, themeMode: ThemeMode.dark`); dark scaffolds are black. Hero
titles: `headlineLarge` 34/41 w700 −0.5 (phone), `headlineMedium` 28/34 w700 −0.5 (sidebar).

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

## Original widgets

The screens are built on the original 0.1.6 widgets. Accessibility they carry without a visual change:

| Class | Name / state | Keyboard | Target | Reduced motion |
| --- | --- | --- | --- | --- |
| `LiquidBounceButton` | `semanticLabel` (pass it localized; English fallback from the 0.1.6 icons), `toggled` | focus ring, Enter/Space/Select/A | ≥ 48 dp (28 dp circle padded) | no bounce, stretch, crossfade |
| `CustomBounceButton` | text inside `child`, or `semanticLabel`; `toggled` | same | ≥ 48 dp | no bounce |
| `CustomTextField` | `hintText` is the name | focus border; `onSubmitted` + `textInputAction` (Enter joins), `focusNode`, `autofocus`, `inputFormatters` (all optional, defaults as 0.1.6) | field height ≥ 48 | — |
| `LiquidGlassContainer`, `CustomCard` | visual only | — | — | — |

Text fields (QA): secret inputs (`CustomTextField(isPassword: true)`, `GlassTextField(obscure: true)`) disable
autocorrect, suggestions, capitalization and smart dashes/quotes, hidden or shown (D2). After a wrong password, clear
instead of selecting (D4): `controller.clear()`.

Shared widgets besides the 0.1.6 classes: `GlassSurface`, `InitialsAvatar`,
`RoomTimeLogo`, and the internals `AppPressable`, `FocusRing`, `GlassEffect`. Feature-level glass pieces live outside
the shared widgets: `GlassTextField`, `GlassDialogButton`, `GlassButtonRow`, `GlassStatusScreen` and the
`showGlass*` dialogs (`presentation/dialogs/glass_dialog.dart`), `VideoVeil` (`presentation/shared`),
`MediaControlButton` / `MediaControlsRow` (`features/room`).
Preview: `img/original-widgets.png` (`original_widgets_preview_test.dart`, `ORIGINAL_PREVIEW_OUT=<png>`).

## Assets and licenses

- Inter 4.1 variable: SIL OFL 1.1, `assets/fonts/inter/OFL.txt`.
- RoomTime logo, app icons, splash and favicons: original work for this project (2026), built from
  `assets/brand/src/roomtime-mark.svg`; the wordmark is Inter Bold converted to outlines (artwork made with an
  OFL font is not subject to the OFL). Details: [identity.md](identity.md#assets-and-licenses).
- The previous `assets/brand/logo.png` (unknown origin) is removed.
- Icons: Material Icons font (Apache-2.0, bundled by `uses-material-design: true`).
- `assets/sounds/*.m4a`: original join/leave chimes synthesised by `assets/sounds/tool/make_sounds.py`
  (AGPL-3.0-only, see NOTICE).
