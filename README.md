# Payload Skills

A collection of skills for AI coding agents. Skills are packaged instructions and scripts that extend agent capabilities.

## Available Skills

### payload

Comprehensive development guidelines for Payload CMS projects. Covers collections, fields, hooks, access control, queries, and plugin development with TypeScript-first patterns.

**When to use:** Working with Payload CMS projects (payload.config.ts, collections, fields, hooks, access control). Debugging validation errors, security issues, relationship queries, transactions, or hook behavior.

**Includes:**

- Quick reference table for common tasks
- Essential patterns (collections, fields, hooks, queries)
- Security pitfalls and best practices
- 10+ reference documents covering all Payload APIs

## Installation

```bash
npx add-skill payloadcms/skills
```

Or manually copy the skill directory to `~/.claude/skills/`.

## Structure

Each skill follows this structure:

```
skills/{skill-name}/
├── SKILL.md          # Agent instructions (required)
├── reference/        # Supporting documentation (optional)
│   └── *.md
└── scripts/          # Helper automation (optional)
    └── *.sh
```

## License

MIT
