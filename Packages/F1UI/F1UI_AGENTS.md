# F1UI Agent Rules

## Purpose

`F1UI` defines the presentation layer for the project.
This package contains SwiftUI screens, namespaced UI components, presentation models, and UI mapping from domain models.

## Allowed contents

- SwiftUI screens
- namespaced UI components under `F1UI`
- presentation models used by screens or components
- screen-specific state handling
- Domain-to-UI mapping in screens or screen-specific view models
- presentation-only formatting helpers
- package documentation

## Forbidden contents

- networking
- DTOs
- API clients
- repository implementations
- business rules
- use case orchestration logic
- Data-layer mapping
- external API access
- app composition code

## Namespace rules

- Reusable UI components must live under the `F1UI` namespace.
- Use nested types to express UI concepts such as `F1UI.Race.Row`.
- Prefer namespaced UI types over top-level names that collide with `F1Domain`.
- Keep multiple visual representations of the same concept under the same namespace branch when possible.

## Components rules

- Components are small reusable rendering units.
- Components must define a nested `ViewData` type.
- Components must receive prepared `ViewData`.
- Components must store it as a private `viewData`.
- Components must remain pure rendering code.
- Components must not have dedicated view models.
- Components must not perform async work.
- Components must not manage loading or error state.
- Components must not depend on repositories.
- Components must not execute use cases.
- Components must not map domain models.
- Components must not contain business logic.
- Do not use generic nested type names such as `Data` or `Model`; use `ViewData`.

## Screens rules

- Screens are application flow entry points.
- Screens call use cases.
- Screens handle loading, error, and navigation state.
- Screens compose components.
- Screens perform Domain-to-UI mapping directly or through a screen-specific view model.
- Do not apply a ViewModel-per-view pattern across the package.
- Do not move screen responsibilities into reusable components.
- Screens must not store optional runtime dependencies.
- Inject runtime dependencies as non-optional async closures.
- Screens must not expose `error.localizedDescription` directly to users.
- Map technical errors to user-friendly messages inside the screen.
- Model state explicitly with `idle`, `loading`, `loaded`, and `error` when that pattern fits the screen.
- Keep screen state deterministic and `Equatable` when possible.

## Mapping rules

- Domain-to-UI mapping happens only in `F1UI`.
- Keep mapping in screens or screen-specific view models.
- Do not place UI mapping in `F1Data` or `F1Domain`.
- Do not add transport-format logic to UI mapping.

## Dependency rules

- `F1UI` may depend on `F1UseCases`.
- `F1UI` may depend on `F1Domain` for identifiers or read-only types when needed.
- `F1UI` must not depend on `F1Data` implementation details.
- `F1UI` must not construct repositories.
- `F1App` performs dependency wiring.

## Folder conventions

- Keep namespace declarations in `Sources/F1UI/Namespace/`.
- Keep reusable visual units in `Sources/F1UI/Components/`.
- Group components by concept such as `Season/`, `Race/`, and `Circuit/`.
- Keep screen entry points in `Sources/F1UI/Screens/`.
- Group screens by flow such as `Seasons/` and `Races/`.
- Keep presentation-only helpers in `Sources/F1UI/Formatting/` when needed.

## Stop conditions

Stop and ask for clarification if any requested change:

- adds networking, DTOs, or repository code to `F1UI`
- moves Domain-to-UI mapping into `F1Data` or `F1Domain`
- introduces a ViewModel-per-view pattern for small reusable components
- asks a component to perform async work or execute use cases
- asks a component to accept domain models directly instead of prepared `ViewData`
- asks a screen to keep optional runtime dependencies
- asks a screen to surface raw technical error descriptions to users
- requires `F1UI` to construct repositories or clients
- conflicts with `ENGINEERING_RULES.md` or other package rules
