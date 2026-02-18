---
name: Template UI
about: Implement user interface, view models, and presentation logic.
title: ''
labels: ''
assignees: ''

---

---
name: UI Feature
about: Implement user interface, view models, and presentation logic.
title: "[UI] "
labels: ["ui", "feature"]
---

## Goal
What screen or UI behavior must be implemented?

---

## Context
Which user interaction or flow requires this UI?

---

## Scope

### IN
- Views
- ViewModels
- Navigation
- State management
- User interaction

### OUT
- Business rules
- Networking
- DTO mapping

---

## Acceptance criteria
- [ ] UI reflects use case output
- [ ] Loading and error states handled
- [ ] No direct data access
- [ ] Uses UseCases layer only
- [ ] Build succeeds

---

## Files to modify
SwiftUI views or view models.

---

## Files NOT to touch
Data infrastructure or domain logic.

---

## Tests required
If applicable, ViewModel tests.

---

## Architecture constraints
- Depends on UseCases
- Must not call API directly

---

## Git
Branch name:
Commit message:

---

## Notes for agent
Special instructions if needed.
