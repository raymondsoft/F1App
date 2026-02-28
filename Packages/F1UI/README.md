# F1UI

`F1UI` is the presentation package for the project. It defines how Formula 1 information is represented in SwiftUI and how screens compose application-facing UI from use cases and domain models.

The package currently implements the first slice of this architecture with `F1UI.Season.Row` and `SeasonsScreen`. This document is the reference for the UI patterns already in use.

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

Current example in the package:

- `F1UI.Season.Row`

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

Screens are application flow entry points such as `SeasonsScreen` or `RacesScreen`.

Screens are responsible for:

- calling use cases
- handling loading state
- handling errors
- performing Domain-to-UI mapping
- composing components
- managing navigation

The screen is the place where application state and presentation meet. Components below the screen should not absorb these responsibilities.

If a state holder is needed, it is screen-specific rather than a default pattern applied to every view.

Current example in the package:

- `SeasonsScreen`

## Dependency injection in screens

Screens must not store optional runtime dependencies.

Use cases are injected as non-optional async closures owned by the screen. The current `SeasonsScreen` pattern is:

```swift
private let load: () async throws -> Data
```

In the concrete screen, the closure wraps the use case:

- `private let getSeasons: @Sendable () async throws -> [Season]`

This pattern avoids invalid runtime state, makes previews safer, and keeps dependency ownership explicit inside the screen.

## UI error handling

UI must not expose raw technical errors to the user.

Specifically, screens must not display `error.localizedDescription` directly.

Screens map technical failures into user-friendly messages inside the screen layer. The current `SeasonsScreen` follows this rule by converting any failure into a generic retry message instead of exposing transport or system details.

## Domain to UI mapping policy

Mapping from `F1Domain` models into `F1UI` representations happens only in the UI layer.

It belongs only in:

- screens
- screen-specific view models if the screen uses one

It must not happen in:

- `F1Data`
- `F1Domain`

This keeps the domain model pure, keeps the data layer focused on transport and repository concerns, and allows the UI layer to create multiple visual representations of the same domain type when needed.

In the current implementation, `SeasonsScreen.makeRowData(from:)` maps `Season` into `F1UI.Season.Row.ViewData`.

## UI state modeling

Screens model UI state explicitly.

The standard state progression is:

- `idle`
- `loading`
- `loaded`
- `error`

State should be deterministic and `Equatable` when possible so mapping and error decisions remain easy to test. The current `SeasonsScreen.ViewState` follows this pattern.

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
  Screens/
    Seasons/
    Races/
  Formatting/
```

Directory purpose:

- `Namespace/`: declares the `F1UI` root namespace and related nested namespaces
- `Components/`: reusable SwiftUI rendering units grouped by domain concept
- `Screens/`: screen entry points that run use cases, map data, and compose components
- `Formatting/`: optional presentation-only helpers such as date or label formatting

This structure is intentionally split by responsibility so reusable views do not drift into screen logic and screen logic does not leak into the component layer.

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
