# Payload Best Practices

## Content Modeling

- Enable `versions: { drafts: true }` by default on content collections; rely on the auto-injected `_status` field rather than adding a custom `status` field
- Use `slugField()` for slugs instead of hand-rolling a unique text field
- Reserve `position: 'sidebar'` for short, at-a-glance fields (status, category, author, date); keep long fields (description, rich text) in the main area

## Security

- Default to restrictive access, gradually add permissions
- Use `overrideAccess: false` when passing `user` to Local API
- Field-level access only returns boolean (no query constraints)
- Never trust client-provided data
- Use `saveToJWT: true` for roles to avoid database lookups

## Performance

- Index frequently queried fields
- Use `select` to limit returned fields
- Set `maxDepth` on relationships to prevent over-fetching
- Prefer query constraints over async operations in access control
- Cache expensive operations in `req.context`

## Data Integrity

- Always pass `req` to nested operations in hooks
- Use context flags to prevent infinite hook loops
- Enable transactions for MongoDB (requires replica set) and Postgres
- Use `beforeValidate` for data formatting
- Use `beforeChange` for business logic

## Type Safety

- Let dev (`autoGenerate`) and `payload build` generate types; run `generate:types` manually only when neither is running
- Import types from generated `payload-types.ts`
- Type your user object: `import type { User } from '@/payload-types'`
- Use field type guards for runtime type checking
- When extracting any Payload value into a named constant — a collection, field, hook, access function, plugin, etc. — annotate it with the matching Payload type (`CollectionConfig`, `Field`, `CollectionBeforeChangeHook`, `Access`, `Plugin`, …) or use `satisfies <Type>`. Without an annotation, string properties like `type: 'text'` widen to `string` and discriminated unions (`Field`, `CollectionConfig`) fail to resolve. Inline literals get this for free via contextual typing; extracted constants do not.

## Organization

- Keep collections in separate files
- Extract access control to `access/` directory
- Extract hooks to `hooks/` directory
- Use reusable field factories for common patterns
- Document complex access control with comments
