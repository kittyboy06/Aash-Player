# 07-AI-Development-Guide.md

# Aash Player AI Development Guide

**Version:** 1.0.0\
**Status:** Draft

------------------------------------------------------------------------

# Executive Summary

This guide defines the workflow, standards, and operational rules for
AI-assisted development of Aash Player. It ensures every AI coding
assistant produces maintainable, production-quality code that aligns
with the project's architecture, documentation, and engineering
principles.

------------------------------------------------------------------------

# 1. Objectives

-   Maintain architectural consistency
-   Enable modular feature development
-   Reduce technical debt
-   Improve code quality
-   Support long-term maintainability

------------------------------------------------------------------------

# 2. AI Development Principles

Every AI implementation must:

-   Follow the System Constitution
-   Respect Clean Architecture
-   Keep business logic platform-independent
-   Maximize shared Flutter code
-   Produce production-ready implementations

------------------------------------------------------------------------

# 3. Development Workflow

``` text
Read Documentation
        │
Understand Requirements
        │
Design Solution
        │
Implement Feature
        │
Write Tests
        │
Review Against Standards
        │
Update Documentation
```

------------------------------------------------------------------------

# 4. Feature Development Lifecycle

1.  Review relevant documentation.
2.  Define acceptance criteria.
3.  Create domain models.
4.  Implement use cases.
5.  Implement repositories.
6.  Build UI.
7.  Write tests.
8.  Update documentation.

------------------------------------------------------------------------

# 5. Mission Structure

Each development task ("Mission") must include:

-   Objective
-   Scope
-   Dependencies
-   Files to Create
-   Files to Modify
-   Acceptance Criteria
-   Definition of Done
-   Test Requirements

------------------------------------------------------------------------

# 6. Coding Standards

-   Flutter + Dart only
-   Riverpod for state management
-   Drift for persistence
-   media_kit for playback
-   audiotags for metadata
-   go_router for navigation

Avoid shortcuts that violate architecture.

------------------------------------------------------------------------

# 7. Architecture Compliance Checklist

Before submitting code, verify:

-   No business logic in widgets
-   Repository pattern followed
-   Use cases implemented
-   Platform code isolated
-   Dependencies point inward

------------------------------------------------------------------------

# 8. Documentation Requirements

Every completed feature must include:

-   Updated design notes
-   API documentation (if applicable)
-   Architecture changes
-   Migration notes (if breaking)

------------------------------------------------------------------------

# 9. Testing Requirements

Required when applicable:

-   Unit Tests
-   Widget Tests
-   Integration Tests
-   Repository Tests
-   Platform Tests

No feature is complete without verification.

------------------------------------------------------------------------

# 10. Git Workflow

Recommended branch naming:

-   feature/`<name>`{=html}
-   fix/`<name>`{=html}
-   refactor/`<name>`{=html}
-   docs/`<name>`{=html}

Commit messages should be concise and descriptive.

------------------------------------------------------------------------

# 11. Review Checklist

-   Builds successfully
-   Lints cleanly
-   Tests pass
-   Documentation updated
-   No duplicated logic
-   No unused code

------------------------------------------------------------------------

# 12. AI Prompt Guidelines

Every AI task should provide:

-   Context
-   Relevant documents
-   Constraints
-   Expected output
-   Acceptance criteria

AI should explain assumptions when requirements are ambiguous.

------------------------------------------------------------------------

# 13. Refactoring Policy

Refactoring is encouraged when it:

-   Improves readability
-   Reduces duplication
-   Simplifies maintenance
-   Preserves behavior

Functional changes require updated tests.

------------------------------------------------------------------------

# 14. Definition of Done

A feature is complete when:

-   Requirements are met
-   Tests pass
-   Documentation is updated
-   Architecture rules are respected
-   Code review checklist is satisfied

------------------------------------------------------------------------

# 15. Future Improvements

-   Automated documentation generation
-   AI-assisted code reviews
-   CI quality gates
-   Architecture validation tools

------------------------------------------------------------------------

# Revision History

  Version   Date            Description
  --------- --------------- ------------------------------
  1.0.0     Initial Draft   Initial AI Development Guide
