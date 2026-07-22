# e2e-pr-assets bundle

This folder packages the `e2e-pr-assets` skill and its helper scripts so teammates can use the same workflow from this repository.

## What is included

- Project skill: `skills/e2e-pr-assets/SKILL.md`
- Helper scripts: `tools/e2e-pr-assets/bin/e2e-*`
- Shared config loader: `tools/e2e-pr-assets/lib/config.sh`
- Bootstrap scripts:
  - `tools/e2e-pr-assets/install.sh`
  - `tools/e2e-pr-assets/check.sh`
- Bundle manifest: `tools/e2e-pr-assets/bundle.json`

## Setup

From the installed skill root:

```bash
bash tools/e2e-pr-assets/check.sh
```

If the check fails, install then re-check:

```bash
bash tools/e2e-pr-assets/install.sh
bash tools/e2e-pr-assets/check.sh
```

The install script links helper commands into `~/.local/bin` (or `$XDG_BIN_HOME`) and validates prerequisites.

If you are running directly from this repository checkout instead of an installed local skill, prefix paths with `skills/e2e-pr-assets/`.

## Configure defaults

For repeat use, store local defaults with the top-level helper command:

```bash
e2e-pr-assets --configure GITHUB_BROWSER_PROFILE /path/to/github-profile
e2e-pr-assets --configure E2E_GITHUB_AUTO_REMOVE_PROFILE 0
e2e-pr-assets --show-config
```

This writes `~/.config/e2e-pr-assets/config` by default, or `$XDG_CONFIG_HOME/e2e-pr-assets/config` when `XDG_CONFIG_HOME` is set.

Environment variables still override config values for one-off runs, so commands like `E2E_MEDIA_AUTO_CLEANUP=0 e2e-attach-pr ...` continue to work.

## Validate manually

```bash
bash tools/e2e-pr-assets/check.sh
bash tools/e2e-pr-assets/bin/e2e-run-script tools/e2e-pr-assets/test/keyboard-overlay.scenario.mjs --repo . --label keyboard-overlay-test --record
```

## Recording Plan

Before recording, create a temporary local `recording-plan.md` outside the repo with separate `Before` and `After` sections.

- Keep this plan out of the visible PR body.
- List the visible step order for each pass.
- State exactly what must be proven in card view and in list view.
- Mirror the same `Before` / `After` plan in a top-of-file comment in any temporary `scenario.mjs`.
- When attaching media, pass the plan to `e2e-attach-pr --plan-file ...` so the `Before` and `After` notes become hidden HTML comments below the matching headings.
- In those hidden comments, call out the verdict explicitly: `Before` should name the incorrect result, and `After` should name the correct result.

## Notes

- The scripts are repository-local and can be versioned/reviewed via PR.
- The install script creates symlinks rather than copying files, so updates in this repo are immediately reflected.
- Default security behavior:
  - Browser auth profile defaults to `/tmp/github-upload-profile`.
  - Temporary browser profile is removed automatically after upload flow unless explicitly disabled.
  - Temporary media artifacts are removed automatically after `e2e-attach-pr` updates the PR body.
  - Persistent defaults can be stored with `e2e-pr-assets --configure ...`.
- `e2e-upload-github-attachments` is check-first for auth:
  - Uses an ephemeral profile by default: `/tmp/github-upload-profile`.
  - If the selected browser profile is already signed in to GitHub, upload proceeds immediately.
  - If not signed in, it opens `e2e-github-login-profile`, waits for manual sign-in detection, then retries upload once automatically.
  - On completion (success/failure), it removes temporary profile directories by default for security.
  - Configure repeat-use defaults with `e2e-pr-assets --configure ...`; explicit env vars still take precedence.
  - Override profile with `GITHUB_BROWSER_PROFILE=/path/to/profile`.
  - Disable auto-removal with `E2E_GITHUB_AUTO_REMOVE_PROFILE=0`.
  - For non-temporary custom paths, removal is skipped unless `E2E_GITHUB_FORCE_REMOVE_PROFILE=1`.
  - Disable auto-open behavior with `E2E_GITHUB_AUTO_LOGIN=0`.
- `e2e-attach-pr` cleans `/tmp/payload-e2e-before|after.{mp4,webm,png}` after a successful PR body update by default.
  - Disable media cleanup with `E2E_MEDIA_AUTO_CLEANUP=0`.
- `e2e-attach-pr --plan-file /path/to/recording-plan.md` copies the plan's `Before` and `After` sections into hidden HTML comments in the PR body, directly below the visible `### Before` and `### After` headings.
- Prefer final proof lines like `Show the document card with the published title. (Incorrect, should be draft title)` and `Show the document card with the draft title. (Correct, shows draft title)` so the hidden comments explain the bug/fix clearly in edit mode.
- `e2e-convert-video` trims the initial blank lead-in by default and can extend that trim automatically when the first meaningful scene change happens later than the standard 1-second startup buffer.
- When the opening poster matters, inspect the first decoded MP4 frame after conversion and before upload. The first frame should already be meaningful UI, not a white loading spinner or blank transition frame.
- If `h264_videotoolbox` is available but fails during conversion, `e2e-convert-video` automatically retries with `libx264`.
