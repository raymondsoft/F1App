---
name: Template Data
about: Implement infrastructure and external API integration (Jolpica, networking,
  DTO, mapping). No business logic.
title: ''
labels: ''
assignees: ''

---

---
name: Data Feature
about: Implement infrastructure and external API integration (Jolpica, networking, DTO, mapping). No business logic.
title: "[Data] "
labels: ["data", "feature"]
---

## Goal
What external data or infrastructure must be implemented?

---

## Context
Which domain use case requires this data?

---

## Scope

### IN
- HTTP clients
- DTO models
- JSON decoding
- Mapping DTO → Domain
- Repository implementations

### OUT
- Business rules
- UI logic
- Domain model changes

---

## Acceptance criteria
- [ ] Networking isolated from Domain
- [ ] DTO models match API structure
- [ ] Mapping produces valid Domain models
- [ ] Error handling implemented
- [ ] Unit tests for decoding and mapping
- [ ] Build succeeds

---

## Files to modify
Expected infrastructure files.

---

## Files NOT to touch
Domain models unless explicitly required.

---

## Tests required
- JSON decoding tests
- Mapping tests
- Repository tests with mocks if applicable

---

## Architecture constraints
- Depends only on Domain
- No SwiftUI
- No business logic decisions

---

## Git
Branch name:
Commit message:

---

## Notes for agent
Special instructions if needed.
