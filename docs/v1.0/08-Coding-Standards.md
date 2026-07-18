# 08-Coding-Standards.md

# Aash Player Coding Standards

**Version:** 1.0.0\
**Status:** Draft

------------------------------------------------------------------------

# Executive Summary

This document defines the coding standards, conventions, and best
practices for the Aash Player project. These standards ensure a clean,
maintainable, scalable, and production-ready Flutter codebase shared
across Android and Windows.

------------------------------------------------------------------------

# 1. Objectives

-   Maintain code consistency
-   Improve readability
-   Reduce technical debt
-   Simplify onboarding
-   Support long-term maintenance

------------------------------------------------------------------------

# 2. General Principles

-   Write self-documenting code
-   Prefer readability over cleverness
-   Keep functions small and focused
-   Eliminate duplication (DRY)
-   Follow SOLID principles
-   Favor composition over inheritance

------------------------------------------------------------------------

# 3. Language Standards

-   Language: Dart
-   Framework: Flutter
-   Null Safety: Required
-   Prefer `final` over mutable variables
-   Use `const` wherever possible

------------------------------------------------------------------------

# 4. Project Structure

    lib/
    │
    ├── app/
    ├── core/
    ├── features/
    ├── shared/
    └── main.dart

Each feature should contain:

    feature/
    ├── data/
    ├── domain/
    ├── presentation/
    └── application/

------------------------------------------------------------------------

# 5. Naming Conventions

## Files

-   snake_case.dart

Examples:

-   song_repository.dart
-   playback_provider.dart

## Classes

PascalCase

Examples:

-   SongRepository
-   PlaybackController

## Variables & Methods

camelCase

Examples:

-   currentSong
-   playNext()

## Constants

camelCase for `const` values, UPPER_SNAKE_CASE only when interoperating
with external/native APIs.

------------------------------------------------------------------------

# 6. Flutter Widget Guidelines

-   One widget per responsibility
-   Prefer StatelessWidget
-   Extract reusable widgets
-   Avoid deeply nested widget trees
-   Keep build methods concise

------------------------------------------------------------------------

# 7. State Management

Riverpod is mandatory.

Rules:

-   One provider per responsibility
-   No business logic in UI
-   Providers call use cases
-   UI observes providers only

------------------------------------------------------------------------

# 8. Architecture Rules

Must follow:

Presentation

↓

Application

↓

Domain

↓

Data

↓

Platform

Forbidden:

-   UI → Database
-   UI → Platform APIs
-   Widgets → SQL
-   Business logic in widgets

------------------------------------------------------------------------

# 9. Error Handling

-   Use typed exceptions where appropriate
-   Convert infrastructure errors into domain-friendly failures
-   Provide meaningful user messages
-   Log unexpected errors

------------------------------------------------------------------------

# 10. Documentation

Every public API should include documentation comments.

Complex logic requires explanatory comments.

Avoid obvious comments.

------------------------------------------------------------------------

# 11. Formatting

-   Use `dart format`
-   Use recommended lints
-   Keep line lengths reasonable
-   Consistent indentation

------------------------------------------------------------------------

# 12. Imports

Import order:

1.  Dart SDK
2.  Flutter SDK
3.  Third-party packages
4.  Project imports

Avoid wildcard exports.

------------------------------------------------------------------------

# 13. Testing Standards

Minimum expectations:

-   Unit Tests
-   Widget Tests
-   Integration Tests

Every bug fix should include a regression test where practical.

------------------------------------------------------------------------

# 14. Git Standards

Branch names:

-   feature/\*
-   fix/\*
-   docs/\*
-   refactor/\*
-   test/\*

Commit style:

-   feat:
-   fix:
-   docs:
-   refactor:
-   test:
-   chore:

------------------------------------------------------------------------

# 15. Code Review Checklist

Before merging:

-   Builds successfully
-   Lints pass
-   Tests pass
-   No dead code
-   Documentation updated
-   Architecture respected

------------------------------------------------------------------------

# 16. Performance Guidelines

-   Minimize rebuilds
-   Prefer lazy loading
-   Cache expensive operations
-   Avoid blocking the UI thread
-   Profile before optimizing

------------------------------------------------------------------------

# 17. Security Guidelines

-   Validate external input
-   Never expose sensitive information
-   Request least-privilege permissions
-   Avoid insecure storage

------------------------------------------------------------------------

# 18. Accessibility

-   Semantic labels
-   Keyboard navigation
-   High contrast
-   Large text support
-   Focus indicators

------------------------------------------------------------------------

# 19. Definition of Done

Code is complete when:

-   Meets requirements
-   Passes tests
-   Follows architecture
-   Meets coding standards
-   Documentation updated

------------------------------------------------------------------------

# 20. Acceptance Criteria

The coding standards are successful when:

-   Code remains readable and maintainable
-   Team members follow consistent conventions
-   Architectural integrity is preserved
-   New contributors can understand the project quickly

------------------------------------------------------------------------

# Revision History

  Version   Date            Description
  --------- --------------- -----------------------------------
  1.0.0     Initial Draft   Initial Coding Standards Document
