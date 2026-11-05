# Security policy

## Reporting a vulnerability

Please report vulnerabilities **privately** through GitHub Security Advisories:
[Report a vulnerability](https://github.com/devleloper/roomtime/security/advisories/new)
(repository **Security** tab → **Advisories** → **Report a vulnerability**).

Do not open a public issue, pull request or discussion for a security problem.

Include what you can of:

- the affected platform (Web, iOS, Android, macOS) and version or commit;
- steps to reproduce, a proof of concept, and the impact you expect;
- whether the problem is already public.

What happens next:

- We acknowledge the report within 7 days and keep you updated in the advisory.
- We aim to release a fix within 90 days, sooner for critical issues, and agree the disclosure date with you.
- We credit you in the advisory and the changelog unless you prefer to stay anonymous.

RoomTime is maintained by volunteers; there is no bug bounty.

## Supported versions

| Version | Supported |
| --- | --- |
| Latest release (`vX.Y.Z` tags) | Yes |
| `main` | Yes, fixes land here first |
| Older releases | No; please upgrade |

No release has been tagged yet; until then only `main` is supported.

## Scope

In scope:

- This Flutter app: storage of the guest id and owner tokens, handling of invite links and deep links, what is sent
  to the backend, logging, platform permissions and configuration.
- The release workflow and the web bundle it builds.

Problems in the RoomTime backend (room API, LiveKit configuration) can be reported the same way; the backend is
maintained separately.

Out of scope:

- Vulnerabilities in LiveKit, Flutter or other dependencies themselves: report them upstream (tell us if
  RoomTime's use of them makes a problem worse).
- The absence of end-to-end media encryption: this is documented (the SFU operator can access media) and planned.
- Volumetric denial of service, social engineering, and findings from automated scanners without a demonstrated
  impact.

## Security model

What the client stores and sends, and what it expects from the backend, is described in
[docs/architecture.md](docs/architecture.md#trust-and-privacy).
