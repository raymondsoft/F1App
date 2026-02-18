---
name: Template App
about: Configure application composition, dependency injection, navigation, and integration
  between layers.
title: ''
labels: ''
assignees: ''

---

---
name: App Feature
about: Configure application composition, dependency injection, navigation, and integration between layers.
title: "[App] "
labels: ["app", "feature"]
---

## Goal
What application-level configuration or integration must be implemented?

---

## Context
Why is this needed for app composition or feature integration?

---

## Scope

### IN
- Dependency injection setup
- Module wiring
- Navigation root
- Environment configuration
- Package integration
- App lifecycle setup

### OUT
- Business logic
- Networking implementation
- DTO parsing
- Domain model definitions
- UI component design

---

## Acceptance criteria
- [ ] All dependencies correctly wired
- [ ] App builds successfully
- [ ] No direct cross-layer violations
- [ ] Integration verified manually
- [ ] No duplicated configuration

---

## Files to modify
App entry point, composition root, configuration files.

---

## Files NOT to touch
Domain, Data, UseCases logic.

---

## Tests required
If applicable, integration smoke tests.

---

## Architecture constraints
- Only wiring and configuration
- Must not implement business rules

---

## Git
Branch name:
Commit message:

---

## Notes for agent
Special instructions if needed.
