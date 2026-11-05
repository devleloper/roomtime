# Contributing to RoomTime

Thank you for helping. This guide covers the development setup, the checks a change must pass, and the rules for
commits and pull requests. By taking part you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

Security problems are not reported in issues: see [SECURITY.md](SECURITY.md).

## Before you start

- For anything larger than a small fix, open an issue first so we can agree on the approach.
- The look is the original FaceTime-like interface and its custom widgets (`lib/presentation/widgets/`). Fix
  problems inside them and build new screens in the same visual language; propose visual changes in an issue first.
- The client follows the room API contract in [`docs/api/openapi.yaml`](docs/api/openapi.yaml); the backend is not
  part of this repository.
- RoomTime must not claim end-to-end encryption anywhere (UI, docs, store text) until media E2EE is implemented and
  verified.
- Never commit secrets, real hostnames, LAN addresses or personal data. Local config (`config/local.json`) and
  signing files (`android/key.properties`) are git-ignored for this reason.

## Development setup

Flutter 3.47.9 (stable); Xcode for iOS and macOS, the Android SDK for Android; optionally `actionlint`.

```bash
cp config/local.example.json config/local.json     # API_BASE_URL of a RoomTime backend
flutter pub get
flutter run --dart-define-from-file=config/local.json
```

Per-platform commands are in the [README](README.md#getting-started).

## Checks

CI ([`.github/workflows/ci.yml`](.github/workflows/ci.yml)) runs these commands; run them before you push:

```bash
dart run build_runner build --delete-conflicting-outputs   # after DI changes; commit lib/core/di/injection.config.dart
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
flutter build web --release --no-web-resources-cdn --dart-define-from-file=config/local.example.json
```

Changes to call flows (create, join, password, reconnect) also need a real two-client call against a backend, for
example the browser and the iOS Simulator ([integration_test/README.md](integration_test/README.md)).

## Commits

### Conventional Commits

Commit messages follow [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/):

```text
<type>(<scope>): <summary in the imperative, lower case, no period>

<optional body: what and why>

Signed-off-by: Your Name <you@example.com>
```

- Types: `feat`, `fix`, `docs`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- Scopes in use: `client`, `ui`, `brand`, `l10n`, `ci`, `repo`.
- Breaking changes: `!` after the scope (`feat(client)!: …`) and a `BREAKING CHANGE:` footer.
- One logical change per commit; formatting-only changes go in their own commit.

### Developer Certificate of Origin (DCO)

Every commit must carry a `Signed-off-by` line whose name and email match the commit author. Add it with:

```bash
git commit -s
```

By signing off you certify the [Developer Certificate of Origin 1.1](https://developercertificate.org/): you wrote
the change or otherwise have the right to submit it under the project's license (AGPL-3.0-only). CI checks the
sign-off on every commit of a pull request. To fix a missing sign-off:

```bash
git commit --amend -s --no-edit            # last commit
git rebase --signoff upstream/main         # every commit of the branch (upstream = devleloper/roomtime)
git push --force-with-lease
```

Use an email you are happy to publish; GitHub's `<id>+<login>@users.noreply.github.com` address works.

**Why DCO and not a CLA:** the DCO is a per-commit statement that keeps your copyright with you and needs no
separate signed agreement, so contributing stays lightweight and everyone receives the code under the same
AGPL-3.0-only terms. A CLA would let one party relicense contributions; RoomTime does not ask for that.

## Pull requests

1. Fork, branch from `main` (`feat/<topic>`, `fix/<topic>`), keep the branch up to date by rebasing.
2. Fill in the pull request template: what changed, why, how you tested it, screenshots for UI changes.
3. All CI jobs must pass. `main` has a linear history: pull requests are merged by squash or rebase.
4. Update docs with behaviour (`docs/design/`, `docs/architecture.md`) and the `[Unreleased]` section of
   [CHANGELOG.md](CHANGELOG.md) for user-visible changes. New user-visible strings go into both ARB files
   (`lib/l10n/app_en.arb`, `app_ru.arb`).

## Code style

- [Effective Dart](https://dart.dev/effective-dart), `flutter_lints`, `dart format`. Layers in `lib/` depend inward
  (presentation → domain ← data); see [docs/architecture.md](docs/architecture.md).
- Colors, spacing and motion come from the theme tokens ([docs/design/tokens.md](docs/design/tokens.md)).
- Comments explain a non-obvious "why", not what the code does.

## License

By contributing you agree that your contributions are licensed under the GNU Affero General Public License v3.0
only ([LICENSE](LICENSE)).
