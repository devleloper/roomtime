## What and why

<!-- What does this change do, and why is it needed? Link the issue: "Closes #123". -->

## How it was tested

<!-- Commands you ran and their results; devices or browsers used. Call-flow changes (create, join,
password, reconnect) need a real two-client call against a backend. -->

## Screenshots

<!-- For UI changes: before and after (the app is dark-only). Delete this section otherwise. -->

## Checklist

- [ ] The PR title follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) (`feat(client): …`).
- [ ] Every commit is signed off (`git commit -s`), see "Developer Certificate of Origin" below.
- [ ] The checks pass locally (see [CONTRIBUTING.md](https://github.com/devleloper/roomtime/blob/main/CONTRIBUTING.md#checks)).
- [ ] Docs are updated with the behaviour (`docs/design/`, `docs/architecture.md`, `CHANGELOG.md` `[Unreleased]`).
- [ ] No secrets, private hostnames, LAN addresses or personal data in code, tests, logs or screenshots.
- [ ] No claim of end-to-end encryption in UI or docs.

## Developer Certificate of Origin

RoomTime uses the [Developer Certificate of Origin 1.1](https://developercertificate.org/) instead of a Contributor
License Agreement. The `Signed-off-by: Name <email>` line that `git commit -s` adds certifies that you wrote the
change or have the right to submit it under the project's license, AGPL-3.0-only. You keep your copyright, nothing
extra has to be signed, and everyone receives your contribution under the same license. CI checks the sign-off on
every commit.
