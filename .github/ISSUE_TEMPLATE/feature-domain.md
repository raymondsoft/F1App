---
name: feature Domain
about: Create or modify domain models, protocols, or business rules. Pure logic only
  — no networking, no UI.
title: ''
labels: ''
assignees: ''

---

---
name: Domain Feature
about: Create or modify domain models, protocols, or business rules. Pure logic only — no networking, no UI.
title: "[Domain] "
labels: ["domain", "feature"]
---

## Goal
What domain concept must be created or changed?

---

## Context
Why is this needed from a business or architecture perspective?

---

## Scope

### IN
- Models
- Value objects
- Protocols
- Domain errors
- Pure business rules

### OUT
- Networking
- Persistence
- UI
- DTO or JSON parsing

---

## Acceptance criteria
- [ ] Public API clearly defined
- [ ] No external dependencies
- [ ] No infrastructure code
- [ ] Unit tests cover logic
- [ ] Build succeeds

---

## Files to modify
List expected files or folders.

---

## Files NOT to touch
Other packages (Data, UI, etc.)

---

## Tests required
Describe unit tests for domain logic.

---

## Architecture constraints
- Must remain platform independent
- Must not import Foundation networking or SwiftUI

---

## Git
Branch name:
Commit message:

---

## Notes for agent
Special instructions if needed.
