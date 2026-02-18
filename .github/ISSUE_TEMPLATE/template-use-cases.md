---
name: Template Use Cases
about: Implement application use cases that orchestrate domain logic and repositories.
title: ''
labels: ''
assignees: ''

---

---
name: UseCases Feature
about: Implement application use cases that orchestrate domain logic and repositories.
title: "[UseCases] "
labels: ["usecases", "feature"]
---

## Goal
Which application action or workflow must be implemented?

---

## Context
What user or system behavior requires this use case?

---

## Scope

### IN
- Application logic
- Coordination of repositories
- Input/output models if needed

### OUT
- Networking details
- UI rendering
- DTO parsing

---

## Acceptance criteria
- [ ] Uses Domain models only
- [ ] Uses repository protocols
- [ ] No infrastructure code
- [ ] Unit tests verify behavior
- [ ] Build succeeds

---

## Files to modify
Use case classes or functions.

---

## Files NOT to touch
Data infrastructure or UI views.

---

## Tests required
Describe behavioral tests.

---

## Architecture constraints
- Depends only on Domain
- Must remain framework independent

---

## Git
Branch name:
Commit message:

---

## Notes for agent
Special instructions if needed.
