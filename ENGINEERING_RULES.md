# Engineering Rules (must-read)

These rules apply to all code and all AI agents in this repository.
If a rule conflicts with a request, the agent must STOP and ask for clarification.

---

## 1) Architecture boundaries

- Each package is a clean layer.
- Do not break dependency direction.
- Data may depend on Domain (and Foundation), but never on UI or App.
- UI must not call external APIs directly.

---

## 2) File organization

### General
- One responsibility per file.
- Avoid monolithic files (no “everything in one .swift”).

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

## 3) External clients (Networking)

- All external HTTP clients must be mockable.
- Prefer generic protocols for testability (e.g. `HTTPClient`).
- Prefer dependency injection over globals (`URLSession.shared` is allowed only as a default).

---

## 4) Swift concurrency

- Prefer native async APIs when available.
  Example: `URLSession.data(from:)`
- Avoid `withCheckedThrowingContinuation` unless bridging is strictly required.

---

## 5) Testing standards (project-wide)

### Framework
- Use Swift Testing (`import Testing`) for all tests.
- Do not introduce XCTest unless explicitly requested.

### Readability
- Every test must have a human-readable name:
  `@Test("Descriptive behavior sentence")`

- Tests must use clear sections:
  `// Given` / `// When` / `// Then`

### Organization
- No top-level helper functions in test files (avoid file-scope helpers like `makeClient()`).
- Test suites must be self-contained (SUT constructed inside the suite).
- Test helpers / test doubles must live in:
  `Tests/<PackageName>Tests/Helpers/`
- Name test doubles accurately (Stub/Fake/Mock).
- If a helper relies on static/global state, tests must run serialized.

---

## 6) Agent operating rules (mandatory)

Before coding:
1) Read this file: `ENGINEERING_RULES.md`
2) Respect scope: modify ONLY the package(s) mentioned in the task.
3) If a change outside scope seems necessary, STOP and explain why.

Every change must:
- compile
- include tests when requested
- keep behavior unchanged unless explicitly requested
