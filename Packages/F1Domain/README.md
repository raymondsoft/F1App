# F1Domain

`F1Domain` is the domain layer for Formula 1 business models used across the project.

It contains stable domain entities, pagination models, and the repository contract needed to access them:

- `Season`
- `Race`
- `Circuit`
- `Location`
- `Driver`
- `Constructor`
- `RaceResult`
- `QualifyingResult`
- `RaceResultTime`
- `QualifyingLapTime`
- `DriverStanding`
- `ConstructorStanding`
- `PageRequest`
- `Page`
- `PaginationError`
- `F1Repository`

It does not contain networking, DTOs, persistence, UI code, app flow, or data-source implementations.

In the project's Clean Architecture, this package defines the language of the core F1 domain. Other layers depend on these models to exchange data without depending on transport or presentation details.

The current structure is intentionally small and responsibility-oriented:

- `Sources/F1Domain/Entities/` holds the domain value types.
- `Sources/F1Domain/Repositories/` holds repository protocols only.
- `Tests/F1DomainTests/Entities/` holds entity tests.
- `Tests/F1DomainTests/Helpers/` holds test-only fixtures.

Other layers interact with `F1Domain` by creating, consuming, or returning these entities, and by conforming to `F1Repository` in implementation packages such as the data layer.

Result timing stays parse-free in Domain:

- `RaceResultTime` makes the difference explicit between a classified race time and a status-like result label.
- `QualifyingLapTime` stores a qualifying session time as an explicit domain wrapper instead of a raw public `String`.

`F1Repository` exposes both collection methods and paged methods for seasons, races, drivers, constructors, race results, qualifying results, and standings.

The package is meant to stay stable, predictable, and independent. Changes here should preserve clear domain modeling and avoid leaking infrastructure or UI concerns into the core models.
