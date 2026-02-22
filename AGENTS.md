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

---

## 4. Testing discipline

When tests are involved:

- Use Swift Testing
- Follow Given / When / Then structure
- Keep test suites self-contained
- Place helpers in Tests/.../Helpers
- Ensure deterministic behavior

---

## 5. Communication rules

Agents must:

- explain assumptions
- report uncertainties
- list modified files
- explain architectural impact
- confirm build and test status

---

## 6. Forbidden actions

Agents must NEVER:

- silently change architecture
- introduce global mutable state
- bypass layer boundaries
- add monolithic files
- switch test frameworks
- modify files outside scope

---

## 7. Definition of done

A task is complete only if:

- code compiles
- tests pass
- rules are respected
- scope respected
- changes documented

Agent must report completion explicitly.
