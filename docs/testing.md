# Testing Standards

This document defines how tests must be written in this repository.

Tests are executable documentation.
They must clearly explain system behavior and structure.

If a test is hard to read, it is considered incorrect even if it passes.

---

## Swift Testing style

- Use `import Testing`
- Use `@Suite` and `@Test("...")`
- Prefer `#expect(...)` for assertions
- Prefer `Issue.record(...)` only when execution must continue after an unexpected path
- Do not introduce XCTest unless explicitly requested

---

## Test structure (required)

Each test must explicitly contain:

    // Given
    (set up data, stubs, fixtures)

    // When
    (call SUT)

    // Then
    (assert expected behavior)

Sections must always be visible, even if minimal.

---

## Test purpose

Every test must serve two roles:

1. Verify correctness  
2. Explain how the system behaves  

Tests must remain understandable without navigating helper implementations.

Important operations must remain visible inside the test body.

---

## SUT guidelines (required)

- SUT must be owned by the suite (no top-level helper constructors).
- Prefer typing SUT as a protocol when possible.
- Construction must happen in suite initializer or inside test.
- Tests must be deterministic.

Example structure:

    @Suite(.serialized)
    struct ExampleTests {
        let sut: SomeProtocol

        init() {
            self.sut = ConcreteType(...)
        }

        @Test("Behavior description")
        func testSomething() async throws {
            // Given
            // When
            // Then
        }
    }

---

## DTO decoding tests (special rules)

DTO decoding tests document the external API contract.

They must show explicitly:

- which fixture is used
- decoding step
- assertions on decoded structure

Do NOT hide decoding behind generic helpers unless duplication becomes significant.

Preferred pattern:

    let data = try loadJSONFixture(named: "seasons")
    let response = try decoder.decode(SeasonsResponseDTO.self, from: data)

DTO tests must remain explicit and self-explanatory.

---

## Fixtures

JSON fixtures represent real external data samples.

Rules:

- Fixtures must be realistic
- Fixtures must live with tests
- Fixtures must be loaded via shared helper
- Fixture loading must use Bundle.module

Example shared helper location:

    Tests/<Module>Tests/Helpers/loadJSONFixture(named:)

---

## Test helpers

Two types of helpers exist.

### Shared helpers

Reusable infrastructure utilities.

Examples:
- fixture loading
- generic test doubles
- common assertions

Rules:
- generic
- reusable across suites
- stored in:
  Tests/<Module>Tests/Helpers/

---

### Local helpers (suite-specific)

Local helpers express the semantic intent of a specific test suite.

Examples:
- decodeSeasonsFixture()

Rules:
- must NOT be generic
- must NOT introduce parameters when fixture is fixed
- must remain private
- must express meaning of test suite
- must not hide important behavior

Local helpers represent the contract of the suite.

---

## Test doubles

Test doubles must live in:

    Tests/<Module>Tests/Helpers/

Naming rules:

- Stub → returns predefined responses
- Mock → records interactions / expectations
- Fake → simplified working implementation

Names must reflect actual behavior.

---

## Assertions

Assertions must be explicit and readable.

Prefer:

    #expect(value == expected)

Avoid complex expressions inside a single assertion.  
Prefer multiple simple assertions.

Assertions must communicate intent clearly.

---

## Concurrency / global state

Avoid global mutable state.

If unavoidable:

- tests must run serialized
- state must be reset deterministically

Suites requiring isolation must use:

    @Suite(.serialized)

---

## Abstraction policy

Avoid premature abstraction in tests.

Do NOT extract shared helpers unless:

- duplication appears multiple times
- readability improves
- test meaning remains explicit

Tests prioritize clarity over DRY in small scopes.

---

## Visibility rules

- Shared helpers → internal or module-visible
- Local helpers → private
- Test doubles → minimal visibility required

Never expose test-only utilities to production code.

---

## Naming conventions

Test names must describe behavior, not implementation.

Good:

    @Test("SeasonsResponseDTO should decode seasons fixture")

Bad:

    @Test("Test decoding")

Names must describe expected outcome.

---

## Determinism

Tests must not depend on:

- network
- time
- randomness
- external services

All inputs must be controlled.

---

## What a good test looks like

A reader must understand:

- what data is used
- what is executed
- what is expected
- why it matters

Without opening any other file.
