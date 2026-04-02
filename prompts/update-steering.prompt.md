---
name: update-steering
description: 'Update existing Kiro steering documents under .kiro/steering/ to match the latest project state.'
argument-hint: Optional focus area or additional context
agent: agent
---

Explore the current project and update the existing steering documents under `.kiro/steering/` (`product.md`, `tech.md`, and `structure.md`) to reflect the latest project version.

## Step 1: Explore the Project

Before making any changes, gather context by reading:
- The existing steering documents under `.kiro/steering/`
- `package.json` — dependencies, scripts, project name
- `tsconfig.json` — TypeScript configuration and strictness settings
- `README.md` — project description and overview (if present)
- `src/` directory tree — understand module layout and naming
- Main entry points and recently added modules

Identify discrepancies between the current codebase and what is documented in the steering files.

## Step 2: Update `product.md`

Update `.kiro/steering/product.md` if there are changes to:
- Core Capabilities: newly added features or retired ones.
- User Roles: any new auth schemas or roles.
- Architecture Philosophy: if the overarching approach has evolved.

Keep bullets concise and focus on the *what* and *why*.

## Step 3: Update `tech.md`

Update `.kiro/steering/tech.md` to reflect:
- Framework or runtime updates.
- New database, ORM, caching, or background job systems.
- External services that were added or removed.
- Updates in development tools or common commands (from `package.json`).
- Path aliases changes in `tsconfig.json`.

Ensure any version modifications are exact.

## Step 4: Update `structure.md`

Update `.kiro/steering/structure.md` to capture:
- Changes in Type Safety rules or observed codebase practices.
- Updates to the Core Directory Structure and Feature Module patterns.
- New file placement rules or naming conventions.
- Emerging architecture patterns (e.g., changes in the Repository, Service, or Route patterns).

Ensure the `inclusion: always` frontmatter remains at the top of `structure.md`. Base the patterns on actual present code.

## Step 5: Verify

Generate a brief changelog or summary detailing exactly what sections across the steering documents were updated to reflect the latest project state.
