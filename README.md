# F1App

## Project overview

`F1App` is a Swift project intended to organize Formula 1 data access, domain modeling, use cases, and UI concerns into separate layers. The current codebase already models core F1 entities and fetches seasons and races from the Jolpica API, while the application target itself is still close to the default Xcode template.

## Architecture overview

The repository is structured around Clean Architecture boundaries.

- `F1Domain` is the core domain layer. It defines stable business entities and repository contracts.
- `F1Data` is the data layer. It talks to the external Jolpica API, decodes transport models, validates and maps them into domain entities, and provides a concrete repository implementation.
- `F1UseCases` is the package reserved for application-specific orchestration. It exists, but is currently only a placeholder target.
- `F1UI` is the package reserved for presentation code. It also exists as a placeholder target.
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
- `F1UseCases`: placeholder package for use-case orchestration.
- `F1UI`: placeholder package for reusable presentation code.

## Dependency direction

Dependency flow is intentionally constrained.

- `F1Domain` must remain independent of data and UI details.
- `F1Data` may depend on `F1Domain`, and currently does.
- `F1UI` must not call external APIs directly.
- DTOs and networking stay in `F1Data`.
- The app target is expected to compose the layers rather than invert dependencies.

Today, the only implemented package dependency is:

`F1Data -> F1Domain`

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
- DTO decoding for seasons and races
- explicit DTO-to-domain mapping
- strict parsing and validation for date, time, and coordinate fields
- package-level tests for domain entities, DTO decoding, mapping, networking, and repository behavior

Declared but not yet implemented beyond placeholders:

- `F1UseCases`
- `F1UI`

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
