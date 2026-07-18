# 08-Coding-Standards-v2.md

# Aash Player Coding Standards (v2.0)

**Version:** 2.0.0\
**Status:** Living Document

------------------------------------------------------------------------

# Executive Summary

This document establishes the engineering standards for the Aash Player
codebase. It defines conventions for project organization, Dart and
Flutter development, Riverpod usage, Clean Architecture implementation,
documentation, testing, security, and performance to ensure a
maintainable and scalable application.

------------------------------------------------------------------------

# 1. Objectives

-   Maintain a consistent codebase
-   Improve readability
-   Reduce technical debt
-   Simplify onboarding
-   Preserve architectural integrity

------------------------------------------------------------------------

# 2. Core Principles

-   Readability over cleverness
-   Keep code simple
-   DRY (Don't Repeat Yourself)
-   SOLID principles
-   Composition over inheritance
-   Prefer immutability

------------------------------------------------------------------------

# 3. Project Structure

``` text
lib/
├── app/
├── core/
├── shared/
├── features/
│   ├── application/
│   ├── data/
│   ├── domain/
│   └── presentation/
└── main.dart
```

Feature-first organization is mandatory.

------------------------------------------------------------------------

# 4. Dart Standards

-   Enable null safety
-   Prefer `final` over mutable variables
-   Use `const` whenever possible
-   Avoid dynamic unless required
-   Keep functions focused and concise

------------------------------------------------------------------------

# 5. Naming Conventions

## Files

-   snake_case.dart

Examples:

-   playback_controller.dart
-   song_repository.dart

## Classes

-   PascalCase

## Variables

-   camelCase

## Constants

-   camelCase for Dart constants
-   UPPER_SNAKE_CASE only for external/native interoperability

------------------------------------------------------------------------

# 6. Flutter Widget Guidelines

-   One widget, one responsibility
-   Prefer StatelessWidget
-   Extract reusable widgets
-   Keep build methods short
-   Avoid deeply nested widget trees

------------------------------------------------------------------------

# 7. Riverpod Guidelines

-   One provider per responsibility
-   Keep providers lightweight
-   Business logic belongs in use cases
-   Providers expose immutable state
-   UI reacts to provider state only

------------------------------------------------------------------------

# 8. Clean Architecture Rules

Allowed dependency direction:

Presentation ↓ Application ↓ Domain ↓ Data ↓ Platform

Forbidden:

-   Widgets → Database
-   Widgets → Platform APIs
-   Domain → Flutter
-   Domain → Drift

------------------------------------------------------------------------

# 9. Error Handling

-   Throw meaningful exceptions internally
-   Translate infrastructure errors into domain failures
-   Log unexpected failures
-   Display user-friendly messages

------------------------------------------------------------------------

# 10. Documentation Standards

Public APIs should include documentation comments.

Complex algorithms require explanatory comments.

Avoid comments that merely repeat the code.

------------------------------------------------------------------------

# 11. Logging

Logging should:

-   Aid debugging
-   Avoid sensitive information
-   Use structured messages
-   Differentiate debug and release output

------------------------------------------------------------------------

# 12. Testing Standards

Minimum expectations:

-   Unit tests
-   Widget tests
-   Integration tests
-   Regression tests for bug fixes

------------------------------------------------------------------------

# 13. Git Standards

Branch naming:

-   feature/\*
-   fix/\*
-   docs/\*
-   refactor/\*
-   test/\*
-   chore/\*

Commit prefixes:

-   feat:
-   fix:
-   docs:
-   refactor:
-   test:
-   chore:

------------------------------------------------------------------------

# 14. Performance Guidelines

-   Avoid unnecessary rebuilds
-   Cache expensive operations
-   Lazy-load data
-   Profile before optimizing
-   Keep UI responsive

------------------------------------------------------------------------

# 15. Security Guidelines

-   Validate external input
-   Never commit secrets
-   Request least-privilege permissions
-   Protect user data
-   Verify imported content

------------------------------------------------------------------------

# 16. Accessibility

Support:

-   Screen readers
-   Keyboard navigation
-   Large text
-   High contrast
-   Semantic labels
-   Visible focus indicators

------------------------------------------------------------------------

# 17. Code Review Checklist

Before merging:

-   Code builds successfully
-   Lints pass
-   Tests pass
-   Architecture respected
-   Documentation updated
-   No unnecessary dependencies

------------------------------------------------------------------------

# 18. Definition of Done

Code is complete when:

-   Requirements are met
-   Tests pass
-   Documentation is updated
-   Coding standards are followed
-   Review checklist is satisfied

------------------------------------------------------------------------

# 19. Future Enhancements

-   Automated lint enforcement
-   Static architecture validation
-   Security scanning
-   Performance benchmarking
-   Documentation generation

------------------------------------------------------------------------

# 20. Acceptance Criteria

Coding standards are successful when:

-   Code remains consistent and maintainable.
-   New contributors can understand the project quickly.
-   Architecture violations are minimized.
-   Reviews become faster and more effective.

------------------------------------------------------------------------

# Revision History

  -----------------------------------------------------------------------
  Version                Date            Description
  ---------------------- --------------- --------------------------------
  2.0.0                  Initial Draft   Expanded coding standards with
                                         project structure, Riverpod
                                         rules, Clean Architecture,
                                         logging, security, and review
                                         guidance.

  -----------------------------------------------------------------------
