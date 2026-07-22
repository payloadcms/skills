# AI Agent Skills

A collection of model-agnostic skills for AI coding agents working with and contributing to Payload.

These skills package repeatable workflows, project knowledge, and helper scripts so contributors can install the same guidance across different agent runtimes.

## Installation

```bash
npx skills add payloadcms/skills
```

## What This Repo Is For

- Payload development workflows
- Contributor and maintainer tasks
- Repeatable PR, debugging, migration, and authoring flows
- Skills that are useful across agent ecosystems, not tied to a single model or editor

## Available Skills

### `payload`

> Comprehensive development guidelines for Payload projects. Covers collections, fields, hooks, access control, queries, and plugin development with TypeScript-first patterns.

**When to use:** Working with Payload projects (payload.config.ts, collections, fields, hooks, access control). Debugging validation errors, security issues, relationship queries, transactions, or hook behavior.

**Covers:**

- **Collections**: Auth, uploads, drafts, live preview configurations
- **Fields**: All field types including relationships, arrays, blocks, joins, virtual fields
- **Hooks**: beforeChange, afterChange, beforeValidate, field hooks
- **Access Control**: Collection, field, and global access patterns including RBAC and multi-tenant
- **Queries**: Local API, REST, and GraphQL with complex operators
- **Database Adapters**: MongoDB, Postgres, SQLite configurations and transactions
- **Advanced Features**: Jobs queue, custom endpoints, localization, plugins

[View full documentation →](skills/payload/README.md)

### `cms-migration`

> Interactive workflow to design Payload collections from source CMS data. Config-first approach: establish data structure through conversation before importing.

**When to use:** Migrating content to Payload from WordPress, Contentful, Strapi, Sanity, Webflow, or other CMSs. Working with data exports (JSON, CSV) that need to be mapped to Payload collections.

**Covers:**

- **Data Analysis**: Identify field types, relationships, and patterns from source data
- **Collection Design**: Generate Payload collection configs through iterative conversation
- **Field Mapping**: Complete reference for all Payload field types with source patterns
- **Migration Patterns**: WordPress, Contentful, Strapi field mappings
- **Common Pitfalls**: Select vs relationship disambiguation, rich text handling

[View full documentation →](skills/cms-migration/SKILL.md)

### `e2e-pr-assets`

> Contributor-focused workflow for attaching before/after admin UI evidence to Payload pull requests with GitHub-inline videos or screenshots.

**When to use:** Preparing or updating a Payload PR that needs reviewer-facing visual proof from e2e flows, especially when the fix is easiest to understand through before/after media in the PR body.

**Covers:**

- **Recording Plans**: Local `Before` / `After` shot lists with hidden PR-body comments
- **Video Evidence**: Record, convert, verify, and upload GitHub-inline H.264 MP4s
- **Screenshot Evidence**: Capture and attach before/after PNGs when screenshots are the right fit
- **Temporary Scenarios**: Agent-authored recording scripts for clearer demos than noisy committed tests
- **PR Body Updates**: Idempotent before/after sections with explicit incorrect/correct proof lines
- **Media Hygiene**: Startup-frame trimming, first-frame verification, and cleanup guidance

[View full documentation →](skills/e2e-pr-assets/README.md)

## Resources

- [Payload Documentation](https://payloadcms.com/docs)
- [Payload GitHub](https://github.com/payloadcms/payload)

## License

MIT
