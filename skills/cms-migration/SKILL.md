---
name: cms-migration
description: Use when user wants to migrate content from another CMS (WordPress, Contentful, Strapi, Sanity, Webflow, etc.) to Payload CMS
---

# CMS Migration to Payload

Interactive workflow to design Payload collections from source CMS data. Config-first approach: establish the data structure through conversation before any data import.

## When to Use

- User mentions migrating content to Payload
- User has data exports (CSV, JSON) from another CMS
- User asks about importing from WordPress, Contentful, Strapi, Sanity, Webflow, etc.

## Workflow

```
Start
  ↓
Ask for data sample
  ↓
Analyze data shape
  ↓
Propose collection config
  ↓
User reviews ──────────────┐
  │                        │
  ├─ changes needed ───→ Adjust config ──→ (back to User reviews)
  │
  └─ looks good ───→ Config confirmed
                            ↓
                    More collections? ──────┐
                            │               │
                            ├─ yes ──→ (back to Ask for data sample)
                            │
                            └─ no ───→ All collections confirmed
                                              ↓
                                      Discuss migration approach
                                              ↓
                                            Done
```

## Phase 1: Data Analysis

When user provides data (JSON, CSV, or describes their schema):

1. **Identify field types** - text, number, date, relationships, media, rich text
2. **Spot patterns** - IDs, timestamps, nested objects, arrays
3. **Note relationships** - foreign keys, embedded refs, linked content types
4. **Flag ambiguities** - fields that could be multiple types, unclear purposes

## Phase 2: Propose Collection Config

Present a Payload collection config based on analysis:

```typescript
// Example output format
export const Posts: CollectionConfig = {
  slug: 'posts',
  fields: [
    { name: 'title', type: 'text', required: true },
    { name: 'content', type: 'richText' },
    { name: 'author', type: 'relationship', relationTo: 'users' },
    // ...
  ],
}
```

**Always explain decisions:**
- "I made `status` a select field with these options because..."
- "This looks like a relationship to authors - should it allow multiple?"
- "The `metadata` object could be a group field or JSON - which do you prefer?"

## Phase 3: Iterate with User

After proposing, ask targeted questions:

- "Does this field need to be required?"
- "Should users be able to add multiple categories?"
- "Is this rich text or plain HTML you want to store as-is?"
- "I see timestamps - do you need Payload's built-in createdAt/updatedAt or custom fields?"

Continue until user confirms: **"This collection config looks good"**

## Phase 4: Additional Collections

After each confirmation, ask:

> "Are there other content types we should create collections for?"

If yes, loop back to Phase 1 with new data sample.

Common related collections to prompt for:
- Media/uploads
- Users/authors
- Categories/tags
- Settings (global)

## Phase 5: Migration Approach

Only after ALL collections are confirmed, discuss data import:

1. **Order matters** - which collections have no dependencies? Migrate those first
2. **Relationship mapping** - how to resolve source IDs to Payload IDs
3. **Media handling** - download/re-upload vs external URLs
4. **Rich text** - HTML conversion needs or keep raw

Offer to generate a seed script or walk through manual import.

## Key Questions by Phase

### Getting Data Sample
- "Can you share a sample of your [content type] data? JSON export, CSV, or paste a few records"
- "What CMS is this from? Knowing the source helps me understand the data shape"

### Reviewing Fields
- "This `author` field has an ID - does it reference another collection?"
- "I see `featured_image` with a URL - should this be an upload field in Payload?"
- "The `blocks` array has different object shapes - is this flexible content like ACF?"

### Confirming Config
- "Here's the collection config. Any fields missing or incorrectly typed?"
- "Should any of these fields be localized?"
- "Any access control needs? (who can read/write)"

### More Collections
- "What other content types exist in your source CMS?"
- "Do you have categories, tags, or taxonomy that posts reference?"
- "Any global settings or site config to migrate?"

## Critical: Select vs Relationship

**This is the most common migration mistake.** Data that looks static often needs to be dynamic.

When you see repeated string values (categories, tags, types, statuses):

```json
{ "category": "Technology" }
{ "category": "News" }
{ "category": "Technology" }
```

**Don't assume it's a select field.** Ask:

> "I see `category` has values like 'Technology', 'News'. Should this be:
> - A **select field** with fixed options (values won't change)
> - A **relationship** to a Categories collection (users can add/edit/remove categories later)"

**Default to relationship** for anything that looks like:
- Categories, tags, topics, labels
- Authors, assignees, reviewers
- Statuses beyond simple draft/published
- Types that might expand over time

**Use select only for:**
- Truly fixed enums (yes/no, draft/published/archived)
- Options defined by business logic, not content (payment status, priority levels)
- Values that would break functionality if changed (role types with code dependencies)

If creating a relationship, remember to add the related collection (Categories, Tags, etc.) to the migration plan.

## Reference Documentation

- **[PAYLOAD-FIELD-REFERENCE.md](reference/PAYLOAD-FIELD-REFERENCE.md)** - Complete Payload field type schemas with examples

## Common Pitfalls

| Issue | How to Handle |
|-------|---------------|
| User provides partial data | Ask for more samples, especially edge cases |
| Unclear relationships | Ask user to describe how content types connect |
| Rich text ambiguity | Clarify: Lexical editor, Slate, or store raw HTML |
| Missing media collection | Always confirm upload collection exists before referencing |
| Overly complex nested data | Consider flattening or using blocks instead of deep groups |
| **Select vs relationship confusion** | Always ask if values should be editable by users |
