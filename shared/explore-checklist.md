# Exploration Checklist

This checklist guides the Explore subagent in scanning a codebase for context before planning or design. Both `Plan Kiro` and `Plan Plus` agents reference this file.

## 1. Detect Project Type

Identify the project's primary language and tech stack from manifest files:

| Manifest File | Ecosystem |
|---------------|-----------|
| `package.json` | Node.js / TypeScript / JavaScript |
| `pyproject.toml` / `setup.py` / `requirements.txt` | Python |
| `Cargo.toml` | Rust |
| `go.mod` | Go |
| `pom.xml` / `build.gradle` / `build.gradle.kts` | Java / Kotlin |
| `*.csproj` / `*.sln` | .NET / C# |
| `Gemfile` | Ruby |
| `composer.json` | PHP |
| `pubspec.yaml` | Dart / Flutter |
| `mix.exs` | Elixir |
| `Package.swift` | Swift |

Read the relevant manifest to understand dependencies, scripts, and project metadata.

## 2. Language & Build Configuration

- **TypeScript/JavaScript**: Read `tsconfig.json` for strictness, path aliases, and target
- **Python**: Read `pyproject.toml` / `setup.cfg` for tool configs (ruff, mypy, pytest)
- **Rust**: Read `Cargo.toml` for edition, features, and workspace structure
- **Go**: Read `go.mod` for module name and Go version
- **Java/Kotlin**: Read `build.gradle` or `pom.xml` for plugins and dependencies
- **General**: Look for linter/formatter configs (`.eslintrc`, `.prettierrc`, `ruff.toml`, `.golangci.yml`, `rustfmt.toml`, etc.)

## 3. Project Structure

- Read `README.md` for project overview (if present)
- Scan the source directory tree to understand module layout and naming conventions
- Identify the main entry point(s)
- Note the directory structure pattern (monorepo, modular, layered, MVC, etc.)

## 4. Domain & Architecture

- Examine data models, schemas, or entities to understand the domain
- Look for API definitions, route files, or service interfaces
- Identify existing patterns: repositories, services, controllers, handlers, middleware, etc.
- Check for shared utilities, helpers, or common modules

## 5. Development Context

- Look for existing docs in `docs/` or similar directories
- Check for steering files (`.kiro/steering/`) that constrain the design
- Check for open GitHub issues or PRs related to the feature
- Identify test setup and conventions (test runner, directory structure, naming)
- Read CI/CD configs for deployment constraints

## 6. Global Rules

- Check if `~/.kiro/user-rules.md` exists and read its constraints
