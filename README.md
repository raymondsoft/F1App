# F1App

## Project overview

`F1App` is a Swift project intended to organize Formula 1 data access, domain modeling, use cases, and UI concerns into separate layers. The current codebase already models core F1 entities and fetches seasons and races from the Jolpica API, while the application target itself is still close to the default Xcode template.

## Architecture overview

The repository is structured around Clean Architecture boundaries.

- `F1Domain` is the core domain layer. It defines stable business entities and repository contracts.
- `F1Data` is the data layer. It talks to the external Jolpica API, decodes transport models, validates and maps them into domain entities, and provides a concrete repository implementation.
- `F1UseCases` is the application layer. It orchestrates domain-facing actions such as loading seasons and races through repository abstractions.
- `F1UI` is the presentation package. It currently contains the first implemented UI slice and follows namespaced components, nested SwiftUI views, screen-driven mapping, and strict separation between reusable components and screens.
- `F1App` is the app composition layer. At the moment it still contains the default SwiftUI and SwiftData template code rather than F1-specific wiring.

The implemented architecture already follows several important rules:

- domain models are isolated from transport details
- DTOs stay inside the data layer
- data mapping happens explicitly in dedicated mapping files
- repositories expose domain types rather than raw API payloads
- parsing is strict for values such as dates, times, and coordinates

## Package structure

- `F1Domain`: domain entities (`Season`, `Race`, `Circuit`, `Location`) and the `F1Repository` protocol.
- `F1Data`: Jolpica API client code, DTOs, mapping logic, data errors, and `JolpicaF1Repository`.
- `F1UseCases`: use-case orchestration built on `F1Domain` repository contracts.
- `F1UI`: SwiftUI presentation package using namespaced components, screen-owned mapping, and explicit UI state.

## Dependency direction

Dependency flow is intentionally constrained.

- `F1Domain` must remain independent of data and UI details.
- `F1Data` may depend on `F1Domain`, and currently does.
- `F1UI` must not call external APIs directly.
- DTOs and networking stay in `F1Data`.
- The app target is expected to compose the layers rather than invert dependencies.

Implemented package dependencies today are:

- `F1Data -> F1Domain`
- `F1UseCases -> F1Domain`
- `F1UI -> F1UseCases`
- `F1UI -> F1Domain`

The documented UI dependency direction is:

- `F1UI` may depend on `F1UseCases`
- `F1UI` may depend on `F1Domain` for identifiers or read-only domain types when needed
- `F1UI` must not depend on `F1Data` implementation details
- `F1App` is responsible for wiring repositories, use cases, and UI together

## UI architecture

The official UI approach is documented in `Packages/F1UI/README.md`.

At a high level:

- reusable UI elements live under the `F1UI` namespace using nested Swift types such as `F1UI.Race.Row`
- screens own loading, error handling, navigation, and Domain-to-UI mapping
- small components remain pure rendering units that receive prepared `ViewData`
- screens inject use cases as async closures instead of storing optional runtime dependencies
- screens map failures to user-friendly messages instead of exposing raw technical errors
- the UI layer does not construct repositories or access networking directly

## Build and test

Build the app target with Xcode:

```sh
xcodebuild -project F1App.xcodeproj -scheme F1App build
```

Run the app target tests:

```sh
xcodebuild -project F1App.xcodeproj -scheme F1App test
```

Run package tests from each package directory:

```sh
cd Packages/F1Domain && swift test
cd Packages/F1Data && swift test
cd Packages/F1UseCases && swift test
cd Packages/F1UI && swift test
```

Testing standards are defined in `docs/testing.md`. The repository standard is Swift Testing, and the package test suites use it. The current UI test target is still the default Xcode-generated XCTest suite.

## AI agent workflow

This repository is developed with AI coding agents under documented repository rules.

At a high level:

- developer agents implement scoped changes inside the allowed package boundaries
- reviewer agents focus on bugs, regressions, and test gaps
- documentation maintainer agents keep Markdown documentation aligned with the current codebase
- hygiene-oriented agents handle small consistency and maintenance tasks

Agents are expected to read the global rules in `AGENTS.md` and `ENGINEERING_RULES.md`, then read any package-specific `*_AGENTS.md` files before modifying a package.

## Repository structure

```text
.
├── AGENTS.md
├── ENGINEERING_RULES.md
├── README.md
├── docs/
│   └── testing.md
├── F1App.xcodeproj
├── F1App/
│   ├── F1AppApp.swift
│   ├── ContentView.swift
│   └── Item.swift
├── F1AppTests/
├── F1AppUITests/
└── Packages/
    ├── F1Data/
    │   ├── Sources/F1Data/
    │   └── Tests/F1DataTests/
    ├── F1Domain/
    │   ├── Sources/F1Domain/
    │   └── Tests/F1DomainTests/
    ├── F1UI/
    │   ├── Sources/F1UI/
    │   └── Tests/F1UITests/
    └── F1UseCases/
        ├── Sources/F1UseCases/
        └── Tests/F1UseCasesTests/
```

## Current implementation status

Implemented:

- domain entities for seasons, races, circuits, and locations
- the `F1Repository` domain protocol
- a concrete Jolpica-backed data repository in `F1Data`
- `F1UseCases` with season and race loading use cases
- DTO decoding for seasons and races
- explicit DTO-to-domain mapping
- strict parsing and validation for date, time, and coordinate fields
- package-level tests for domain entities, DTO decoding, mapping, networking, and repository behavior
- first UI implementation slice with `F1UI.Season.Row`, `SeasonsScreen`, and UI mapping tests

Not yet implemented:

- remaining `F1UI` screens and components beyond the initial seasons slice

Not yet integrated into the F1 architecture:

- the `F1App` target, which still uses the default SwiftUI and SwiftData sample code
- the app-level test targets, which are still close to their generated templates

## Contributing

Keep contributions small, accurate, and aligned with the existing architecture.

- respect package boundaries
- avoid introducing cross-layer dependencies
- keep DTOs in the data layer
- use Swift Testing for new tests unless a task explicitly requires otherwise
- update documentation when stable package structure or rules change
- follow `AGENTS.md`, `ENGINEERING_RULES.md`, and package-specific agent files when present
