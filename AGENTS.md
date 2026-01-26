# Payload Skills Repository

This document provides guidance for AI coding agents (Claude Code, Cursor, Copilot, etc.) working with this repository.

## Repository Overview

A collection of skills for AI coding agents. Skills are packaged instructions and scripts that extend agent capabilities.

## Creating a New Skill

### Directory Structure

```
skills/{skill-name}/
├── SKILL.md          # Required - Agent instructions
├── reference/        # Optional - Supporting documentation
│   └── *.md
└── scripts/          # Optional - Helper automation
    └── *.sh
```

### Naming Conventions

- **Directories:** kebab-case (e.g., `payload`, `react-best-practices`)
- **Main file:** `SKILL.md` (uppercase, exact filename)
- **Scripts:** kebab-case with `.sh` extension
- **Reference docs:** UPPERCASE with `.md` extension

### SKILL.md Format

Each skill file must include:

1. **Frontmatter** with name and description
2. **Overview** section explaining purpose
3. **Quick Reference** for common tasks (optional)
4. **Essential Patterns** with code examples
5. **Reference Documentation** links (if applicable)

Example structure:

```markdown
---
name: skill-name
description: When to use this skill. Trigger phrases and use cases.
---

# Skill Title

Brief description of what this skill covers.

## Quick Reference

| Task | Solution   | Details                                                |
| ---- | ---------- | ------------------------------------------------------ |
| Do X | `method()` | [REFERENCE.md#section](reference/REFERENCE.md#section) |

## Essential Patterns

### Pattern Name

\`\`\`ts
// Code example
\`\`\`

## Reference Documentation

- **[REFERENCE.md](reference/REFERENCE.md)** - Description
```

## Best Practices

### Context Efficiency

- Keep SKILL.md under 500 lines
- Write specific, trigger-phrase-inclusive descriptions
- Use progressive disclosure via reference files
- Prefer scripts over inline code for complex operations
- Link to supporting files one level deep

### Description Guidelines

The `description` frontmatter field is critical for skill discovery. Include:

- Primary use cases
- Trigger phrases users might say
- Technology/framework names
- Problem types the skill addresses

Example:

```yaml
description: Use when working with Payload projects (payload.config.ts, collections, fields, hooks, access control). Use when debugging validation errors, security issues, relationship queries, transactions, or hook behavior.
```

### Reference Files

Reference files should:

- Focus on one topic each
- Include code examples with comments
- Use consistent heading structure
- Link back to related sections

### Script Requirements

If including scripts:

```bash
#!/bin/bash
set -e  # Fail fast

# Status messages to stderr
echo "Processing..." >&2

# Machine-readable output to stdout
echo '{"status": "success"}'
```

## End-User Installation

### Claude Code

Copy skill to `~/.claude/skills/`:

```bash
npx add-skill payloadcms/skills
```

### claude.ai

Add SKILL.md content to project knowledge or paste directly.

## Existing Skills

### payload

Payload development guidelines covering:

- Collections, fields, hooks, access control
- TypeScript patterns and type safety
- Security pitfalls and best practices
- Query operators (Local/REST/GraphQL)
- Plugin development

Location: `skills/payload/`
