# F1UI

`F1UI` is the presentation package for the project. It defines how Formula 1 information is represented in SwiftUI and how screens compose application-facing UI from use cases and domain models.

The package currently contains only a placeholder target. This document defines the UI architecture that the package is expected to implement.

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

They are responsible only for rendering already-prepared UI data. Components stay synchronous and deterministic:

- no async work
- no loading state
- no repository dependency
- no use case execution
- no direct dependency on data-layer concerns

This keeps components easy to reuse, preview, and test.

Components are not paired with dedicated view models.

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

## Domain to UI mapping policy

Mapping from `F1Domain` models into `F1UI` representations happens only in the UI layer.

It belongs only in:

- screens
- screen-specific view models if the screen uses one

It must not happen in:

- `F1Data`
- `F1Domain`

This keeps the domain model pure, keeps the data layer focused on transport and repository concerns, and allows the UI layer to create multiple visual representations of the same domain type when needed.

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

`F1App` is the composition layer.

It is responsible for wiring:

`HTTPClient -> API -> Repository -> UseCases -> UI`

`F1UI` must not construct repositories or data clients. It receives dependencies from the composition layer and focuses on presentation behavior only.

## Current status

The package target exists, but the documented UI architecture has not yet been implemented in source files. This README is the reference for that future work.
