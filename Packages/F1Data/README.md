# F1Data

`F1Data` is the data layer for the project. It is responsible for loading raw Formula 1 data from external sources, validating it, and mapping it into `F1Domain` entities.

Today, the package contains a concrete repository implementation backed by the Jolpica API. It currently supports loading seasons and races.

This package contains:

- networking abstractions and HTTP client code
- endpoint construction for the Jolpica API
- response DTOs that model the external JSON payloads
- mapping from DTOs to domain entities
- a concrete `F1Repository` implementation
- data-layer errors

This package does not contain UI code, app flow, domain business modeling, or use-case orchestration. Those concerns belong to other layers.

In the project's Clean Architecture, `F1Data` sits between external systems and the rest of the application. It may depend on `F1Domain`, but `F1Domain` must not depend on it. This keeps transport details, parsing logic, and repository implementations out of the domain layer.

The current folder structure is organized by responsibility:

- `Sources/F1Data/Networking/` contains the HTTP client protocol, the Jolpica HTTP client, the API wrapper, and endpoint building.
- `Sources/F1Data/DTO/` contains the raw response models that match the external JSON structure.
- `Sources/F1Data/Mapping/` contains explicit DTO-to-domain conversion logic.
- `Sources/F1Data/Repositories/` contains the concrete repository implementation exposed to the rest of the app.
- `Sources/F1Data/Errors/` contains data-layer errors.
- `Tests/F1DataTests/` mirrors these responsibilities with focused test suites and shared helpers.

Other layers interact with `F1Data` through domain-facing interfaces. `F1Data` conforms to `F1Domain.F1Repository` and returns domain entities such as `Season` and `Race` rather than raw DTOs.

The package is designed to keep external API details isolated. DTOs remain internal to the data layer, mapping is explicit, and parsing is strict for values such as dates, times, coordinates, and HTTP responses.
