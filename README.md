# AI Agent Skills

A collection of skills for AI coding agents. Skills are packaged instructions and scripts that extend agent capabilities.

## Installation

```bash
npx skills add payloadcms/skills
```

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

## Resources

- [Payload Documentation](https://payloadcms.com/docs)
- [Payload GitHub](https://github.com/payloadcms/payload)

## License

MIT
