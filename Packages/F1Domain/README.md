# F1Domain

`F1Domain` is the domain layer for Formula 1 business models used across the project.

It contains stable domain entities and the repository contract needed to access them:

- `Season`
- `Race`
- `Circuit`
- `Location`
- `F1Repository`

It does not contain networking, DTOs, persistence, UI code, app flow, or data-source implementations.

In the project's Clean Architecture, this package defines the language of the core F1 domain. Other layers depend on these models to exchange data without depending on transport or presentation details.

The current structure is intentionally small:

- `Sources/F1Domain/Entities/` holds the domain value types.
- `Sources/F1Domain/Repositories/` holds repository protocols only.
- `Tests/F1DomainTests/Entities/` holds entity tests.
- `Tests/F1DomainTests/Helpers/` holds test-only fixtures.

Other layers interact with `F1Domain` by creating, consuming, or returning these entities, and by conforming to `F1Repository` in implementation packages such as the data layer.

The package is meant to stay stable, predictable, and independent. Changes here should preserve clear domain modeling and avoid leaking infrastructure or UI concerns into the core models.
