# 07-AI-Development-Guide-v2.md

# Aash Player AI Development Guide (v2.0)

**Version:** 2.0.0\
**Status:** Living Document

------------------------------------------------------------------------

# Executive Summary

This document defines how AI assistants should participate in the
development of Aash Player. It establishes prompt standards, engineering
workflows, review rules, architecture constraints, documentation
expectations, and validation procedures so AI-generated work remains
consistent with the project's engineering principles.

------------------------------------------------------------------------

# 1. Objectives

-   Produce production-ready code
-   Preserve Clean Architecture
-   Reduce technical debt
-   Standardize AI-assisted development
-   Improve maintainability and documentation

------------------------------------------------------------------------

# 2. AI Engineering Principles

Every AI contribution must:

-   Follow the System Constitution
-   Respect architectural boundaries
-   Prefer shared Flutter code
-   Keep business logic platform-independent
-   Explain assumptions when requirements are unclear

------------------------------------------------------------------------

# 3. Standard Development Workflow

``` text
Read Documentation
        │
Analyze Requirements
        │
Design Solution
        │
Implement Feature
        │
Write Tests
        │
Self Review
        │
Update Documentation
```

------------------------------------------------------------------------

# 4. Mission Template

Every AI task ("Mission") should include:

-   Objective
-   Background
-   Scope
-   Constraints
-   Dependencies
-   Files to Create
-   Files to Modify
-   Expected Output
-   Acceptance Criteria
-   Definition of Done
-   Rollback Plan

------------------------------------------------------------------------

# 5. Prompt Template

Recommended prompt sections:

-   Project Context
-   Relevant Documents
-   Existing Architecture
-   Coding Standards
-   Task Description
-   Expected Deliverables
-   Validation Rules

------------------------------------------------------------------------

# 6. Feature Development Lifecycle

1.  Review requirements
2.  Review architecture
3.  Design domain models
4.  Implement use cases
5.  Implement repositories
6.  Build UI
7.  Write tests
8.  Update documentation
9.  Verify against coding standards

------------------------------------------------------------------------

# 7. Architecture Compliance

AI must verify:

-   No business logic in widgets
-   Providers remain lightweight
-   Repository pattern followed
-   Platform code isolated
-   Dependencies point inward
-   Public APIs documented

------------------------------------------------------------------------

# 8. Refactoring Guidelines

Refactoring should:

-   Preserve behavior
-   Reduce duplication
-   Improve readability
-   Simplify maintenance

Large refactors require updated tests and documentation.

------------------------------------------------------------------------

# 9. Documentation Policy

Every completed feature must update:

-   Architecture documents
-   API references (if applicable)
-   Migration notes
-   Changelog (for user-facing changes)

------------------------------------------------------------------------

# 10. Testing Expectations

AI-generated changes should include:

-   Unit tests
-   Widget tests
-   Integration tests (where appropriate)
-   Regression tests for bug fixes

------------------------------------------------------------------------

# 11. Code Review Checklist

Before completion verify:

-   Builds successfully
-   Lints pass
-   Tests pass
-   No dead code
-   No unnecessary dependencies
-   Documentation updated

------------------------------------------------------------------------

# 12. Migration Guidance

When changing architecture or data models:

-   Preserve compatibility where practical
-   Document breaking changes
-   Provide migration strategy
-   Update related documentation

------------------------------------------------------------------------

# 13. AI Review Prompts

Suggested review tasks:

-   Architecture review
-   Security review
-   Performance review
-   Accessibility review
-   Refactoring review
-   Documentation review

------------------------------------------------------------------------

# 14. Future Improvements

-   Automated architecture validation
-   AI-generated ADR drafts
-   Documentation synchronization
-   Intelligent code review assistants
-   Continuous prompt quality improvements

------------------------------------------------------------------------

# 15. Acceptance Criteria

The AI development guide is complete when:

-   AI consistently produces architecture-compliant code.
-   Documentation remains synchronized.
-   Features include appropriate tests.
-   AI outputs are reviewable, maintainable, and production-ready.

------------------------------------------------------------------------

# Revision History

  -----------------------------------------------------------------------
  Version                Date            Description
  ---------------------- --------------- --------------------------------
  2.0.0                  Initial Draft   Expanded AI development guide
                                         with mission templates, prompt
                                         standards, architecture
                                         validation, review workflows,
                                         and migration guidance.

  -----------------------------------------------------------------------
