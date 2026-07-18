# 07-AI-Development-Guide-v3.md

# Aash Player AI Development Guide (v3.0)

**Version:** 3.0.0\
**Status:** Living AI Engineering Manual

------------------------------------------------------------------------

# Executive Summary

This document defines how AI assistants contribute to the Aash Player
codebase. It standardizes prompts, engineering workflows, architecture
validation, review procedures, documentation practices, and
implementation rules so AI-generated work is production-ready and
consistent.

------------------------------------------------------------------------

# 1. Objectives

-   Produce maintainable production-quality code
-   Preserve Clean Architecture
-   Reduce ambiguity
-   Standardize AI collaboration
-   Keep documentation synchronized

------------------------------------------------------------------------

# 2. AI Operating Principles

AI must:

-   Follow the System Constitution
-   Respect dependency rules
-   Prefer shared Flutter code
-   Explain assumptions
-   Never bypass repositories or use cases

------------------------------------------------------------------------

# 3. Standard Development Workflow

``` text
Read Docs
   │
Analyze Requirements
   │
Design Solution
   │
Implement
   │
Write Tests
   │
Self Review
   │
Update Documentation
```

------------------------------------------------------------------------

# 4. Mission Template

Every mission should define:

-   Objective
-   Background
-   Scope
-   Constraints
-   Dependencies
-   Files to Create
-   Files to Modify
-   Deliverables
-   Acceptance Criteria
-   Definition of Done
-   Rollback Plan

------------------------------------------------------------------------

# 5. Prompt Library

Standard prompt categories:

-   New Feature
-   Bug Fix
-   Refactor
-   Architecture Review
-   Performance Optimization
-   Security Review
-   Documentation Update
-   Migration
-   Test Generation

------------------------------------------------------------------------

# 6. Feature Implementation Order

1.  Domain models
2.  Repository interfaces
3.  Use cases
4.  Repository implementations
5.  Providers
6.  UI
7.  Platform integrations
8.  Tests
9.  Documentation

------------------------------------------------------------------------

# 7. Architecture Validation

Verify:

-   Dependency direction
-   Repository boundaries
-   Provider responsibilities
-   Platform isolation
-   No business logic in widgets
-   Public API documentation

------------------------------------------------------------------------

# 8. Code Generation Rules

Generated code should:

-   Be null-safe
-   Prefer immutable models
-   Use meaningful names
-   Follow project structure
-   Avoid unnecessary abstraction
-   Include documentation where appropriate

------------------------------------------------------------------------

# 9. Refactoring Policy

Refactors must:

-   Preserve behavior
-   Reduce duplication
-   Improve readability
-   Maintain test coverage
-   Update documentation

------------------------------------------------------------------------

# 10. Testing Expectations

Every feature should include:

-   Unit tests
-   Widget tests
-   Integration tests (where applicable)
-   Regression tests for fixes

------------------------------------------------------------------------

# 11. Documentation Policy

AI must update:

-   Architecture documents
-   Changelog (user-facing changes)
-   API references
-   Migration notes
-   Related specifications

------------------------------------------------------------------------

# 12. Review Checklist

Before completion:

-   Builds successfully
-   Lints pass
-   Tests pass
-   Documentation updated
-   Architecture preserved
-   No dead code
-   No unnecessary dependencies

------------------------------------------------------------------------

# 13. AI Prompt Examples

Feature Prompt:

``` text
Implement feature following Clean Architecture.
Create tests.
Update documentation.
Do not modify unrelated modules.
```

Bug Fix Prompt:

``` text
Reproduce issue.
Fix root cause.
Add regression test.
Update changelog if user-facing.
```

------------------------------------------------------------------------

# 14. Future Improvements

-   Automated architecture validation
-   AI-generated ADRs
-   Prompt quality scoring
-   Documentation synchronization
-   Intelligent code review agents

------------------------------------------------------------------------

# 15. Acceptance Criteria

The AI guide is complete when:

-   AI consistently follows project architecture.
-   Features include appropriate tests.
-   Documentation stays synchronized.
-   Generated code is reviewable and maintainable.

------------------------------------------------------------------------

# Revision History

  -----------------------------------------------------------------------
  Version                Date            Description
  ---------------------- --------------- --------------------------------
  3.0.0                  Initial Draft   Expanded AI development guide
                                         into an implementation manual
                                         with workflows, prompt library,
                                         validation rules, review
                                         checklists, and coding policies.

  -----------------------------------------------------------------------
