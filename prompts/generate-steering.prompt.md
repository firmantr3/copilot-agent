---
name: generate-steering
description: 'Generate Kiro steering documents for the current project under .kiro/steering/.'
argument-hint: Optional focus area or additional context about the project
agent: agent
---

Explore the current project and generate three steering documents under `.kiro/steering/`: `product.md`, `tech.md`, and `structure.md`.

## Step 1: Explore the Project

Before writing anything, gather context by reading:
- Look for manifest files (`package.json`, `pyproject.toml`, `Cargo.toml`, etc.) — to understand dependencies and project metadata.
- Config files (`tsconfig.json`, `setup.cfg`, etc.) — to understand language configuration and strictness settings.
- `README.md` — project description and overview (if present)
- Source directory tree (e.g., `src/`, `app/`, `lib/`) — understand module layout and naming
- Main entry point — see how the app is composed
- Domain models/schemas — understand domain entities
- Any existing docs in `docs/` — additional context about architecture and features

Do not skip this step. The quality of the steering documents depends on your understanding of the actual codebase.

## Step 2: Generate `product.md`

Create `.kiro/steering/product.md` using this template:

```markdown
# Product Overview

{1–2 sentence summary of what the project is and who it serves}

## Core Capabilities

- **{Feature Area}**: {brief description}
- {repeat for each major capability}

## User Roles

- **{Role}**: {what they do in the system}
- {repeat for each user type}

## Architecture Philosophy

{1–2 sentences describing the architectural approach and why it was chosen}
```

Guidelines:
- Focus on the *what* and *why*, not the *how*
- Keep bullets concise (one line each)
- Derive capabilities from the actual modules and features you found in `src/modules/`
- Derive user roles from auth schemas, route prefixes, or middleware

## Step 3: Generate `tech.md`

Create `.kiro/steering/tech.md` using this template:

```markdown
# Technology Stack

## Runtime & Framework

- **Runtime**: {runtime and key characteristics}
- **Framework**: {web/app framework and notable traits}
- **Language**: {primary language(s) and notable config, e.g., TypeScript strict mode}

## Database & ORM

- **Database**: {database engine and version if known}
- **ORM**: {ORM and why it was chosen, e.g. type-safety}
- **Migrations**: {migration tool and strategy}
- **Caching**: {caching layer and what it's used for}

## Background Jobs

- **Queue System**: {queue library and backend}
- **Workers**: {how workers are organized}
- **Job Patterns**: {patterns used, e.g. fire-and-forget, await}

## External Services

- **Storage**: {object storage solution}
- **Search**: {search engine if present}
- **Payment**: {payment providers if present}
- {add or remove service entries as applicable}

## Development Tools

- **Package/Dependency Manager**: {package manager}
- **Testing**: {test runner and strategy}
- **API Documentation**: {API doc generation tool if present}
- **Local Services**: {local infrastructure approach, e.g. Docker Compose}

## Common Commands

### Development
```bash
{key dev commands from package.json scripts}
```

### Testing
```bash
{key test commands}
```

### Database
```bash
{key database commands}
```

### Build & Deploy
```bash
{key build/start commands}
```

## Module Resolution & Aliases

{List configured path aliases, e.g., from `tsconfig.json`, or module resolution rules}
```

Guidelines:
- Extract exact commands from `package.json` scripts
- Extract path aliases from `tsconfig.json`
- Only include service categories that are actually used in the project
- State version numbers where discoverable (docker-compose, package deps)

## Step 4: Generate `structure.md`

Create `.kiro/steering/structure.md` using this template:

```markdown
---
inclusion: always
---

# Project Structure & Architecture Patterns

## Language-Level Safety & Linting

{Describe the strictness policy, e.g., TypeScript strict mode, Python mypy rules, or Rust clippy config. What is forbidden and what is required. Base this on config files and observed code patterns.}

### Forbidden Practices
- ❌ {practice that violates type safety}
- {repeat}

### Required Practices
- ✅ {required pattern}
- {repeat}

## Architecture Overview

{1–2 sentences describing the overall architectural pattern}

### Core Directory Structure

```
{Reproduce the actual src/ directory tree with annotations for each top-level folder}
```

## File Placement Rules

### When Creating New Features

1. **{Category}** → `{path}`
   - {description}
   - Example: `{example path}`
{repeat for each category}

## Module File Pattern

Detect and document the actual module file pattern from the codebase. For example:

```
src/modules/{module}/{feature}/
├── {feature}.routes.ts      # {description}
├── {feature}.service.ts     # {description}
├── {feature}.repository.ts  # {description}
├── {feature}.dto.ts         # {description}
└── {feature}.test.ts        # {description}
```
*(Adapt the extension and structure to match the project's actual language and architecture)*

## Critical Architecture Patterns

### Repository Pattern

{Describe the base repository class, how to extend it, and show a correct vs incorrect example using actual schema imports from the codebase.}

### Service Layer Pattern

{Describe how services orchestrate repositories, show a correct vs incorrect typed example.}

### Route Pattern

{Describe how routes are defined using the framework, show correct vs incorrect example. Note any framework-specific inference behaviors to preserve.}

## Naming Conventions

- **Files**: {convention} (e.g., `kebab-case.ts`)
- **Classes**: {convention}
- **Functions**: {convention}
- **Constants**: {convention}
- **Database tables**: {convention}

## Import & Module Resolution Patterns

{Show the preferred import style using path aliases vs relative imports, or package imports, with correct/incorrect examples.}

## Database Schema Organization

{List schema files and their locations, and what domain each covers.}

## Testing Patterns

### Unit Tests
{describe unit test conventions}

### Integration Tests
{describe integration test conventions}

## Module Registration

{Show how modules are registered in the app entry point.}
```

Guidelines:
- The `inclusion: always` frontmatter ensures this file is always loaded into agent context
- Use actual import paths from the codebase in examples, not placeholders
- Base the "Forbidden/Required" safety section on both config files (e.g., `tsconfig.json`) and observed code patterns
- Reproduce the real directory tree rather than inventing structure

## Step 5: Verify

After writing all three files:
1. Confirm each file exists under `.kiro/steering/`
2. Check that `structure.md` has the `inclusion: always` frontmatter
3. If `product.md` has no frontmatter, that is correct — it is loaded on demand
4. Summarize what was written and highlight any areas where the project details were ambiguous or inferred
