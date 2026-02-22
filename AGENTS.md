# Agent Operating Guide

This repository is developed with AI coding agents.
Agents must follow this guide strictly.

---

## 1. Mandatory reading order

Before implementing anything, read:

1. ENGINEERING_RULES.md
2. docs/testing.md (if tests are involved)
3. Package-specific rules (if present)
4. The assigned task / issue

If any rule conflicts with the task, STOP and ask for clarification.

Agents must be able to explain which rules apply to the current task before implementation.

---

## 2. Scope of work

Agents must modify ONLY the package(s) specified in the task.

Do not:
- modify other packages
- change architecture
- refactor unrelated code
- introduce new dependencies

If a change outside scope seems required:
STOP and explain why.

---

## 3. Implementation workflow

For every task:

1. Understand requirements
2. Identify affected layer(s)
3. Verify compliance with architecture
4. Implement minimal solution
5. Add or update tests (if requested)
6. Ensure project builds
7. Ensure tests pass
8. Report results

Agents must prefer the smallest correct implementation.
Avoid speculative design or future-proof abstractions.

---

## 4. Testing discipline

When tests are involved:

- Use Swift Testing
- Follow Given / When / Then structure
- Keep test suites self-contained
- Place shared helpers in Tests/.../Helpers
- Ensure deterministic behavior
- Prefer explicit tests over abstract tests
- Tests must remain readable without navigating helper implementations

DTO decoding tests must show the decoding step explicitly unless otherwise instructed.

---

## 5. Test helper policy

Two categories of helpers exist.

### Shared helpers
Reusable infrastructure utilities.

Examples:
- loadJSONFixture(named:)

Rules:
- must be generic
- stored in Tests/<Module>Tests/Helpers/
- may be reused across suites

### Local helpers
Express the intent of a specific test suite.

Examples:
- decodeSeasonsFixture()

Rules:
- must NOT be generic
- must NOT introduce parameters if fixture is fixed
- must express test semantics
- must remain private to the suite

Local helpers represent the semantic contract of the test suite.

---

## 6. DTO implementation rules

When implementing response DTOs:

- One root response DTO per file
- Represent JSON hierarchy using nested types
- Do not create independent top-level DTO types for nested structures
- DTOs must remain internal to the Data layer unless explicitly required
- DTOs represent raw external data only
- No business logic inside DTOs

Separate DTO files only when a type is reused across multiple endpoints.

---

## 7. Abstraction policy

Avoid premature abstraction.

Do NOT extract helpers or shared logic unless:

- duplication appears multiple times
- abstraction improves readability
- abstraction does not hide system behavior

Clarity is preferred over DRY in small scopes.

---

## 8. Documentation update policy

Agents must update documentation when implementation decisions become stable.

Agents may update:

- DTO organization rules
- test structure rules
- helper design rules
- file structure conventions
- feature implementation status

Agents must NOT modify:

- architecture principles
- layer responsibilities
- system design philosophy

If unsure, ask before modifying documentation.

---

## 9. Communication rules

Agents must:

- explain assumptions
- report uncertainties
- list modified files
- explain architectural impact
- confirm build and test status
- explain why design choices were made
- identify any rule interpretation applied

---

## 10. Forbidden actions

Agents must NEVER:

- silently change architecture
- introduce global mutable state
- bypass layer boundaries
- add monolithic files without justification
- switch test frameworks
- modify files outside scope
- introduce generic abstractions without explicit need

---

## 11. Definition of done

A task is complete only if:

- code compiles
- tests pass
- rules are respected
- scope respected
- changes documented (if required)
- behavior verified

Agent must report completion explicitly.

---

## 12. Failure protocol

If an agent cannot complete a task safely, it must:

1. Stop implementation
2. Describe the blocking issue
3. Explain why rules prevent progress
4. Propose possible solutions

Agents must never guess architecture decisions.

---

## 13. Principle of operation

Agents operate under these priorities:

1. Correctness
2. Architectural integrity
3. Clarity
4. Minimal change
5. Reusability (only when justified)

Clarity and architectural consistency always take precedence over convenience.

---

## 14. Git workflow (mandatory)

Agents must use a structured Git workflow for every task.

### Branching

Agents must NEVER commit directly to main (or default branch).

For each task, create a dedicated branch:

feature/<short-description>
fix/<short-description>
refactor/<short-description>
test/<short-description>

Branch name should reflect the task scope.

Example:
feature/data-races-dto

---

### Commits

Agents must create meaningful commits.

Rules:
- group related changes into logical commits
- do not create one giant commit when multiple logical steps exist
- do not create excessive micro-commits

Each commit message must be descriptive and structured.

Preferred format:

<type>: <short summary>

Examples:
feat: add RacesResponseDTO
test: add decoding tests for races endpoint
refactor: extract HTTPClient protocol

---

### Commit message requirements

Commit messages must explain:

- what was implemented
- why it was implemented (if not obvious)
- scope of change

Avoid vague messages like:
"update"
"fix stuff"
"changes"

---

### Before finishing a task

Agent must ensure:

- branch is up to date with base branch
- project builds
- tests pass
- changes are committed

Agent must report:

- branch name
- commit list
- final status

---

### Forbidden Git actions

Agents must NEVER:

- commit directly to main
- rewrite history of shared branches
- force push without explicit permission
- create unrelated changes in the same branch
- mix multiple features in one branch

---

### Definition of task completion (Git)

A task is not complete until:

- changes are committed
- work is isolated in a dedicated branch
- commit messages are structured
- agent reports Git status
