# AI Agent Skills

A collection of skills for AI coding agents. Skills are packaged instructions and scripts that extend agent capabilities.

## Installation

### Version-matched Payload skill (recommended)

Newer Payload releases ship this skill inside the `payload` npm package. Prefer that copy for application development because its guidance was released with the version of Payload installed in the project.

Check whether the installed package includes it:

```bash
test -f node_modules/payload/skills/payload/SKILL.md
```

Agents do not automatically discover skills under `node_modules`. For an existing project, add this pointer at the project root:

```md
<!-- AGENTS.md -->
# AI Agent

Before performing any Payload-related work, read and follow `node_modules/payload/skills/payload/SKILL.md`.
Treat that bundled skill as authoritative for the installed Payload version.
```

Claude Code reads `CLAUDE.md`, so add an import for the shared instructions:

```md
<!-- CLAUDE.md -->
@AGENTS.md
```

In a monorepo, point to the `node_modules/payload` belonging to the workspace that contains the Payload application. Projects created by a compatible version of `create-payload-app` receive these files automatically. See [payloadcms/payload#17652](https://github.com/payloadcms/payload/pull/17652) for the bundled-skill design and setup details.

After confirming the bundled file exists and adding the pointers, remove or disable any standalone `payload` skill already installed for the project.

### Standalone legacy fallback

Use this repository only when the installed `payload` package does not contain `skills/payload/SKILL.md`:

```bash
npx skills add payloadcms/skills
```

> [!WARNING]
> Use one delivery channel per project. Enabling both copies puts two skills named `payload` in scope and can produce conflicting guidance.

## Available Skills

### `payload`

> Legacy fallback providing comprehensive development guidelines for Payload projects whose installed package does not include a bundled skill.

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

## Resources

- [Payload Documentation](https://payloadcms.com/docs)
- [Payload GitHub](https://github.com/payloadcms/payload)

## License

MIT
