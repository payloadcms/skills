# Payload Skill for AI Coding Agents

Agent skill providing comprehensive guidance for Payload development with TypeScript patterns, field configurations, hooks, access control, and API examples.

## Choose the Right Copy

Newer Payload releases include a version-matched copy at `node_modules/payload/skills/payload/SKILL.md`. Use that bundled copy when it exists. This repository remains a legacy fallback for Payload releases that do not ship the skill.

For an existing project, direct agents to the bundled copy from `AGENTS.md`:

```md
# AI Agent

Before performing any Payload-related work, read and follow `node_modules/payload/skills/payload/SKILL.md`.
Treat that bundled skill as authoritative for the installed Payload version.
```

Add `@AGENTS.md` to `CLAUDE.md` for Claude Code. In a monorepo, adjust the path to the workspace containing the Payload application.

Feature-detect the bundled file instead of assuming a version cutoff:

```bash
test -f node_modules/payload/skills/payload/SKILL.md
```

After adding the bundled-skill pointer, remove or disable any standalone `payload` skill already installed for the project. Do not enable both copies in one project: they share the `payload` name and may provide conflicting guidance. See [payloadcms/payload#17652](https://github.com/payloadcms/payload/pull/17652) for details.

## What's Included

The `payload` skill provides expert guidance on:

- **Collections**: Auth, uploads, drafts, live preview configurations
- **Fields**: All field types including relationships, arrays, blocks, joins, virtual fields
- **Hooks**: beforeChange, afterChange, beforeValidate, field hooks
- **Access Control**: Collection, field, and global access patterns including RBAC and multi-tenant
- **Queries**: Local API, REST, and GraphQL with complex operators
- **Database Adapters**: MongoDB, Postgres, SQLite configurations and transactions
- **Advanced Features**: Jobs queue, custom endpoints, localization, plugins

## Usage

When installed as a legacy fallback, the agent will automatically invoke the skill when you're working on Payload projects. The skill activates when you:

- Edit `payload.config.ts` files
- Work with collection or global configurations
- Ask about Payload-specific patterns
- Need guidance on fields, hooks, or access control

You can also explicitly invoke it:

```
@payload how do I implement row-level access control?
```

## Documentation Structure

```
skills/payload/
├── SKILL.md                              # Main skill file with quick reference
└── reference/
    ├── FIELDS.md                         # All field types and configurations
    ├── COLLECTIONS.md                    # Collection patterns
    ├── HOOKS.md                          # Hook patterns and examples
    ├── ACCESS-CONTROL.md                 # Basic access control
    ├── ACCESS-CONTROL-ADVANCED.md        # Advanced access patterns
    ├── QUERIES.md                        # Query patterns and APIs
    ├── ADAPTERS.md                       # Database and storage adapters
    └── ADVANCED.md                       # Jobs, endpoints, localization
```

## Resources

- [Payload Documentation](https://payloadcms.com/docs)
- [GitHub Repository](https://github.com/payloadcms/payload)
- [Examples](https://github.com/payloadcms/payload/tree/main/examples)
- [Templates](https://github.com/payloadcms/payload/tree/main/templates)

## License

MIT
