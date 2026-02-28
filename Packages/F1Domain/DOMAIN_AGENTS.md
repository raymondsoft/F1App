# F1Domain Agent Rules

## Purpose

`F1Domain` defines the core Formula 1 domain model shared by other packages.
This package contains domain entities and repository contracts only.

## Allowed contents

- Domain entities under `Sources/F1Domain/Entities/`
- Repository protocols under `Sources/F1Domain/Repositories/`
- Domain-focused tests under `Tests/F1DomainTests/`
- Test fixtures under `Tests/F1DomainTests/Helpers/`
- Package documentation for this package

## Forbidden contents

- DTOs
- Networking code
- API clients
- persistence code
- UI or app-layer code
- repository implementations
- mappers tied to external formats
- feature flow, coordinators, or view models
- global mutable state

## Dependency restrictions

- Keep dependency direction clean: `F1Domain` must not depend on Data, UI, or App packages.
- Do not add implementation knowledge from another layer into this package.
- Foundation usage is allowed when required by the existing domain model.
- Do not introduce new package dependencies without explicit instruction.

## Modeling rules

- Model domain concepts as stable, framework-light value types.
- Keep domain types focused on business meaning, not transport format.
- Prefer the most restrictive access control that still satisfies package usage.
- Keep files small and single-purpose.
- Do not add infrastructure concerns to entities.
- Do not create abstractions unless they are required by the current domain model.

## Repository rules

- `Sources/F1Domain/Repositories/` contains protocols only.
- Repository protocols define domain-facing operations and return domain entities.
- Do not add repository implementations to this package.
- Do not expose data-layer or API-specific details through repository protocols.

## Folder conventions

- Put entity types in `Sources/F1Domain/Entities/`.
- Put repository protocols in `Sources/F1Domain/Repositories/`.
- Keep production code under `Sources/F1Domain/`.
- Keep tests under `Tests/F1DomainTests/`.
- Keep reusable test fixtures in `Tests/F1DomainTests/Helpers/`.
- Place entity tests in `Tests/F1DomainTests/Entities/`.

## Test placement rules

- Test only `F1Domain` types in `Tests/F1DomainTests/`.
- Place entity behavior tests in `Tests/F1DomainTests/Entities/`.
- Place shared test fixtures in `Tests/F1DomainTests/Helpers/`.
- Do not place production helpers in the test target.
- Follow repository-wide testing rules from `docs/testing.md`.

## Stop conditions

Stop and ask for clarification if any requested change:

- requires editing code outside `Packages/F1Domain/`
- introduces DTOs, networking, persistence, or UI concerns
- requires a repository implementation instead of a protocol
- changes package dependency direction
- moves files or changes package structure without an existing decision
- conflicts with `ENGINEERING_RULES.md` or `docs/testing.md`
