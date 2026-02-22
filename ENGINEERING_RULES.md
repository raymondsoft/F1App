# Engineering Rules (must-read)

These rules apply to all code and all AI agents in this repository.
If a rule conflicts with a request, the agent must STOP and ask for clarification.

---

## 1) Architecture boundaries

- Each package is a clean layer.
- Do not break dependency direction.
- Data may depend on Domain (and Foundation), but never on UI or App.
- UI must not call external APIs directly.
- Domain must not depend on Data implementation details.
- DTOs belong strictly to the Data layer.

---

## 2) File organization

### General

- One responsibility per file.
- Avoid monolithic files (no “everything in one .swift”).
- Prefer structural clarity over excessive file fragmentation.

### Data package conventions (F1Data)

Recommended structure:

Sources/F1Data/
- Errors/
- Networking/
- DTO/
- Mapping/
- Repositories/

Tests/F1DataTests/
- Helpers/
- Networking/
- DTO/
- Mapping/
- Repositories/

---

## 3) DTO organization (Data layer)

DTOs represent raw external data and must reflect the structure of the JSON payload.

Rules:

- One root response DTO per file.
- Internal JSON hierarchy must be represented using nested types.
- Nested JSON structures must NOT be declared as independent top-level DTOs.
- DTOs must remain internal unless explicitly required otherwise.
- DTOs contain no business logic.
- DTOs model transport format, not domain semantics.

Separate files are allowed only when a DTO type is reused across multiple endpoints.

---

## 4) External clients (Networking)

- All external HTTP clients must be mockable.
- Prefer generic protocols for testability (e.g. HTTPClient).
- Prefer dependency injection over globals.
- URLSession.shared is allowed only as a default.
- Networking must not leak transport concerns into Domain.

---

## 5) Swift concurrency

- Prefer native async APIs when available.
  Example: URLSession.data(from:)
- Avoid withCheckedThrowingContinuation unless bridging is strictly required.
- Avoid callback-style networking in new code.

---

## 6) Testing standards (project-wide)

### Framework

- Use Swift Testing (import Testing) for all tests.
- Do not introduce XCTest unless explicitly requested.

### Readability

- Every test must have a human-readable name:
  @Test("Descriptive behavior sentence")

- Tests must use explicit structure:
  // Given / // When / // Then

### Purpose

Tests have two goals:
1. Verify correctness
2. Document system structure

Tests must remain understandable without navigating helper implementations.

### Organization

- No top-level helper functions in test files.
- Test suites must be self-contained (SUT created inside suite).
- Shared test helpers must live in:
  Tests/<PackageName>Tests/Helpers/
- Name test doubles accurately (Stub / Fake / Mock).
- If a helper relies on static/global state, tests must run serialized.

---

## 7) Fixture handling

JSON fixture loading is infrastructure and must be shared.

Rules:

- Use a shared fixture loader helper.
- Shared helpers must be generic.
- Shared helpers live in:
  Tests/<PackageName>Tests/Helpers/
- Fixture loading must use Bundle.module.

---

## 8) Test helper design

Two categories of helpers exist.

### Shared helpers

Reusable infrastructure utilities.

Examples:
- loadJSONFixture(named:)

Rules:
- generic
- reusable across suites
- no test-specific semantics

### Local helpers (suite-specific)

Local helpers express the intent of a test suite.

Examples:
- decodeSeasonsFixture()

Rules:
- must NOT be generic
- must NOT accept parameters if fixture is fixed
- must remain private to the suite
- must express test meaning
- must not hide important behavior

Local helpers represent the semantic contract of the test suite.

---

## 9) DTO decoding tests

DTO decoding tests must remain explicit.

Each test must clearly show:

- which fixture is used
- decoding step
- assertions on decoded structure

Avoid abstracting decoding into reusable helpers unless duplication becomes significant.

DTO tests document the external API contract.

---

## 10) Abstraction policy

Avoid premature abstraction.

Do NOT extract shared logic unless:

- duplication appears multiple times
- readability improves
- behavior remains explicit
- abstraction does not hide system structure

Clarity is preferred over DRY in small scopes.

---

## 11) Access control

Use the most restrictive visibility possible.

- DTOs default to internal
- test helpers default to private
- avoid exposing implementation details across layers

---

## 12) Agent operating rules (mandatory)

Before coding:

1) Read this file: ENGINEERING_RULES.md
2) Respect scope: modify ONLY the package(s) mentioned in the task
3) If a change outside scope seems necessary, STOP and explain why

Agents must implement the minimal correct solution.
Agents must not introduce speculative abstractions.

Every change must:

- compile
- include tests when requested
- keep behavior unchanged unless explicitly requested
- respect architecture boundaries

---

## 13) Design priorities

When making decisions, follow this order:

1. Correctness
2. Architectural integrity
3. Clarity
4. Minimal change
5. Reusability (only when justified)

Clarity and architectural consistency always take precedence over convenience.
