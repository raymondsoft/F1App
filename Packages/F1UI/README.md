# F1UI

`F1UI` is the presentation package for the project. It defines how Formula 1 information is represented in SwiftUI and how screens compose application-facing UI from use cases and domain models.

The package now contains a broader presentation slice covering seasons, races, circuits, drivers, constructors, results, qualifying results, and standings. This document is the reference for the UI patterns currently in use.

## UI architecture approach

The UI layer uses namespaced UI components, nested SwiftUI views, and screen-level mapping from domain models to UI models.

It does not use a traditional ViewModel-per-view pattern. Small reusable views stay as direct SwiftUI rendering units. Screen-specific state objects are optional and exist only when a screen needs them.

This approach exists for four reasons:

- avoid naming collisions with `F1Domain` types such as `Race`, `Circuit`, and `Season`
- make UI types easy to discover through autocomplete
- group related visual representations under one concept
- allow multiple views of the same domain concept without renaming domain models

## F1UI namespace pattern

Reusable UI elements live under the `F1UI` namespace.

Examples:

- `F1UI.Race.Row`
- `F1UI.Circuit.Row`
- `F1UI.Season.Row`
- `F1UI.Driver.Row`
- `F1UI.Constructor.Row`
- `F1UI.Result.Row`
- `F1UI.Qualifying.Row`
- `F1UI.Standing.Row`

The namespace is built with nested types through Swift extensions:

```swift
public enum F1UI {}

public extension F1UI {
    enum Race {}
}

public extension F1UI.Race {
    struct Row: View { ... }
}
```

This keeps UI naming explicit. A domain `Race` remains a domain model, while `F1UI.Race.Row` is a specific visual representation of that concept.

Current component examples in the package:

- `F1UI.Season.Row`
- `F1UI.Circuit.Row`
- `F1UI.Race.Row`
- `F1UI.Driver.Row`
- `F1UI.Constructor.Row`
- `F1UI.Result.Row`
- `F1UI.Qualifying.Row`
- `F1UI.Standing.Row`

## UI layer responsibilities

`F1UI` contains:

- presentation models
- SwiftUI components
- screens
- UI-specific formatting helpers when needed
- explicit mapping from domain models into UI data used by screens and components

`F1UI` does not contain:

- networking
- DTOs
- repository implementations
- business rules
- use case orchestration logic
- external API access

The goal is to keep the package focused on presentation and keep infrastructure concerns outside the UI layer.

## Components and screens

The UI layer is split into two categories with different responsibilities.

### Components

Components are small reusable visual units such as `F1UI.Race.Row`, `F1UI.Circuit.Row`, or `F1UI.Season.Row`.

They are responsible only for rendering already-prepared UI data. Each component defines a nested `ViewData` type, receives that `ViewData` in its initializer, stores it as a private `viewData`, and renders from that presentation model. Components stay synchronous and deterministic:

- no async work
- no loading state
- no repository dependency
- no use case execution
- no direct dependency on data-layer concerns
- no Domain-to-UI mapping
- no business logic

This keeps components easy to reuse, preview, and test.

Components are not paired with dedicated view models.

The nested `ViewData` pattern exists to make the Domain-to-UI boundary explicit, keep mapping testable, provide a stable presentation model, avoid long initializer parameter lists, and let component APIs evolve without exposing domain models directly.

Use the exact name `ViewData`.

- Do use `struct ViewData`
- Do not use generic names such as `Data`
- Do not use generic names such as `Model`

### Screens

Screens are application flow entry points such as `SeasonsScreen`, `RacesScreen`, or the paged season-detail lists.

Screens are responsible for:

- calling use cases
- handling loading state
- handling errors
- performing Domain-to-UI mapping
- composing components
- managing navigation

The screen is the place where application state and presentation meet. Components below the screen should not absorb these responsibilities.

If a state holder is needed, it is screen-specific rather than a default pattern applied to every view.

Current screen examples in the package:

- `SeasonsScreen`
- `RacesScreen`
- `DriversScreen`
- `ConstructorsScreen`
- `RaceResultsScreen`
- `QualifyingResultsScreen`
- `DriverStandingsScreen`
- `ConstructorStandingsScreen`

## Dependency injection in screens

Screens must not store optional runtime dependencies.

Use cases are injected as non-optional async closures owned by the screen. The current paged screen pattern is:

```swift
private let loadPage: @Sendable (PageRequest) async throws -> Page<DomainModel>
```

Concrete screens wrap their use cases into those closures in the public initializer:

- `private let getSeasonsPage: @Sendable (PageRequest) async throws -> Page<Season>`
- `private let getDriversPage: @Sendable (Season.ID, PageRequest) async throws -> Page<Driver>`

This pattern avoids invalid runtime state, keeps previews safe, and leaves pagination orchestration outside `F1UI`.

## UI error handling

UI must not expose raw technical errors to the user.

Specifically, screens must not display `error.localizedDescription` directly.

Screens map technical failures into user-friendly messages inside the screen layer. The current screens follow this rule by converting failures into generic retry messages instead of exposing transport or system details.

## Domain to UI mapping policy

Mapping from `F1Domain` models into `F1UI` representations happens only in the UI layer.

It belongs only in:

- screens
- screen-specific view models if the screen uses one

It must not happen in:

- `F1Data`
- `F1Domain`

This keeps the domain model pure, keeps the data layer focused on transport and repository concerns, and allows the UI layer to create multiple visual representations of the same domain type when needed.

Examples in the current implementation:

- `SeasonsScreen.makeRowData(from:)` maps `Season` into `F1UI.Season.Row.ViewData`
- `RaceResultsScreen.makeRowData(from:)` maps `RaceResult` into `F1UI.Result.Row.ViewData`
- `DriverStandingsScreen.makeRowData(from:)` maps `DriverStanding` into `F1UI.Standing.Row.ViewData`

## UI state modeling

Screens model UI state explicitly.

The standard state progression is:

- `idle`
- `loading`
- `loaded`
- `error`

For paged lists, screens may expand this into explicit state fields such as:

- `items`
- `isLoadingInitial`
- `isLoadingMore`
- `hasMore`
- `nextOffset`
- `error`

State should remain deterministic and `Equatable` when possible so mapping and error decisions remain easy to test.

## Package dependency rules

`F1UI` may depend on:

- `F1UseCases`
- `F1Domain` for identifiers or read-only domain types when needed

`F1UI` must not depend on:

- `F1Data` networking implementation details
- DTOs or API transport models

The app layer performs wiring. `F1UI` should consume use cases and presentation inputs, not construct infrastructure.

## Recommended folder structure

The intended source layout is:

```text
Sources/F1UI/
  Namespace/
  Components/
    Season/
    Race/
    Circuit/
    Driver/
    Constructor/
    Result/
    Qualifying/
    Standing/
  Screens/
    Seasons/
    Races/
    Drivers/
    Constructors/
    RaceResults/
    QualifyingResults/
    Standings/
    Shared/
  Formatting/
```

Directory purpose:

- `Namespace/`: declares the `F1UI` root namespace and related nested namespaces
- `Components/`: reusable SwiftUI rendering units grouped by domain concept
- `Screens/`: screen entry points that run use cases, map data, and compose components
- `Formatting/`: optional presentation-only helpers such as date or label formatting

This structure is intentionally split by responsibility so reusable views do not drift into screen logic and screen logic does not leak into the component layer.

## Test structure

`F1UI` tests follow the same responsibility split as production code.

Use:

- `Tests/F1UITests/Components/` for component `ViewData` contracts
- `Tests/F1UITests/Screens/` for screen mapping and state helpers

- component tests live in `Tests/F1UITests/Components/`
- screen tests live in `Tests/F1UITests/Screens/`
- shared helpers live only in `Tests/F1UITests/Helpers/`

Use one dedicated test file per tested type and match the file name to that type, for example `SeasonRowTests.swift` for `F1UI.Season.Row` and `SeasonsScreenTests.swift` for `SeasonsScreen`.

The full rule is defined in `docs/testing.md` under `UI Test Structure`.

## App composition responsibility

`F1App` is the composition root.

It is responsible for wiring:

`HTTPClient -> API -> Repository -> UseCases -> UI`

It also owns root navigation entry and environment configuration.

`F1UI` must not construct repositories or data clients. It receives dependencies from the composition layer and focuses on presentation behavior only.

## Current status

Implemented today:

- namespace root in `Sources/F1UI/Namespace/`
- `F1UI.Season.Row` as a namespaced reusable component
- nested `ViewData` for `F1UI.Season.Row`
- `SeasonsScreen` with async closure injection, explicit screen state, friendly error mapping, and Domain-to-UI mapping
- Swift Testing coverage for screen mapping and user-facing error state

Planned but not yet implemented:

- additional component namespaces such as `F1UI.Race.Row` and `F1UI.Circuit.Row`
- additional screens such as `RacesScreen`
