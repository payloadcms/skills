# E2E PR Assets Skill

Contributor-focused skill for producing reviewer-friendly before/after admin UI evidence for Payload pull requests.

## What's Included

The `e2e-pr-assets` skill bundles:

- `SKILL.md` with the end-to-end workflow and decision points
- `tools/e2e-pr-assets/bin/e2e-pr-assets` for help and local default configuration
- `tools/e2e-pr-assets/bin/` helper commands for recording, conversion, upload, and PR-body updates
- `tools/e2e-pr-assets/check.sh` and `tools/e2e-pr-assets/install.sh` bootstrap scripts
- `tools/e2e-pr-assets/test/keyboard-overlay.scenario.mjs` as a lightweight recording fixture

## Usage

Once installed, the agent can invoke this skill when a Payload PR needs visual regression evidence. It is especially useful when:

- a before/after video tells the bug story more clearly than test output
- the existing e2e suite is too noisy for reviewer-facing evidence
- the PR body needs inline GitHub videos or screenshots
- reviewers need hidden implementation notes in the PR body edit view, not visible reviewer text

## Setup

From the installed skill root:

```bash
bash tools/e2e-pr-assets/check.sh
```

If the check fails:

```bash
bash tools/e2e-pr-assets/install.sh
bash tools/e2e-pr-assets/check.sh
```

When working directly from this repository instead of an installed local skill, prefix commands with `skills/e2e-pr-assets/`, for example:

```bash
bash skills/e2e-pr-assets/tools/e2e-pr-assets/check.sh
```

To configure repeat-use defaults after install:

```bash
e2e-pr-assets --configure GITHUB_BROWSER_PROFILE /path/to/github-profile
e2e-pr-assets --show-config
```

The config layout includes an `Available keys` comment section and a `Configured keys` section so the file itself stays readable when opened directly. `e2e-pr-assets --show-config` prints the config path first and then shows that same file content.

## Workflow Highlights

- Write a temporary local recording plan with separate `Before` and `After` sections.
- Record the bug state and fixed state using the same scenario steps.
- Convert videos to GitHub-inline H.264 MP4 files and verify the first decoded frame when the opening poster matters.
- Upload media through GitHub attachments, then update the PR body with idempotent `Before` / `After` sections.
- Keep explanatory shot lists hidden inside HTML comments so reviewers only see the videos unless they inspect edit mode.

## Repository Layout

```text
skills/e2e-pr-assets/
├── SKILL.md
└── tools/e2e-pr-assets/
    ├── README.md
    ├── check.sh
    ├── install.sh
    ├── bin/
    ├── lib/
    └── test/
```

## Resources

- [Payload GitHub](https://github.com/payloadcms/payload)
- [Payload Documentation](https://payloadcms.com/docs)
