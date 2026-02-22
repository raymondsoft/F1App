# Testing Standards

## Swift Testing style

- Use `import Testing`
- Use `@Suite` and `@Test("...")`
- Prefer `#expect(...)` for assertions
- Prefer `Issue.record(...)` only when you must keep running after an unexpected path.

## Test structure (required)

Each test must have:

// Given
(set up data, stubs)

// When
(call SUT)

// Then
(assert)

## SUT guidelines (required)

- SUT must be owned by the suite (no top-level helper functions).
- Prefer typing SUT as a protocol when possible (e.g. `HTTPClient`).

Example:

@Suite(.serialized)
struct ExampleTests {
    let sut: SomeProtocol

    init() {
        // setup
        self.sut = ConcreteType(...)
    }

    @Test("Behavior description")
    func testSomething() async throws {
        // Given
        // When
        // Then
    }
}

## Helpers

- Test doubles go in: `Tests/.../Helpers/`
- Name accurately:
  - Stub: returns predefined responses
  - Mock: records calls / expectations
  - Fake: simplified implementation

## Concurrency / global state

- Avoid static mutable state in helpers.
- If unavoidable, suites must be `.serialized`.
