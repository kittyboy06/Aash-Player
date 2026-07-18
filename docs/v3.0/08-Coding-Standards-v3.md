# 08-Coding-Standards-v3.md

# Aash Player Coding Standards (v3.0)

**Version:** 3.0.0\
**Status:** Living Engineering Standard

------------------------------------------------------------------------

# Executive Summary

This document defines the mandatory coding standards for Aash Player. It
establishes conventions for Dart, Flutter, Riverpod, Clean Architecture,
testing, documentation, performance, security, and code review to ensure
a consistent, maintainable, and production-ready codebase.

------------------------------------------------------------------------

# 1. Objectives

-   Maintain consistency
-   Improve readability
-   Reduce technical debt
-   Enable safe collaboration
-   Preserve architectural integrity

------------------------------------------------------------------------

# 2. Engineering Principles

-   Readability over cleverness
-   SOLID principles
-   DRY where appropriate
-   Composition over inheritance
-   Immutability by default
-   Explicit over implicit

------------------------------------------------------------------------

# 3. Project Structure

``` text
lib/
├── app/
├── core/
├── shared/
├── features/
│   ├── presentation/
│   ├── application/
│   ├── domain/
│   └── data/
└── main.dart
```

Every feature follows the same layered structure.

------------------------------------------------------------------------

# 4. Dart Standards

-   Enable null safety
-   Prefer `final`
-   Use `const` where possible
-   Avoid `dynamic`
-   Keep functions focused
-   Avoid deeply nested logic

Example:

``` dart
final song = repository.getSong(id);
```

------------------------------------------------------------------------

# 5. Naming Conventions

-   Files: `snake_case.dart`
-   Classes: `PascalCase`
-   Variables: `camelCase`
-   Methods: `camelCase`
-   Private members: `_camelCase`

Names should describe intent clearly.

------------------------------------------------------------------------

# 6. Flutter Guidelines

-   Widgets have a single responsibility
-   Prefer StatelessWidget
-   Extract reusable widgets
-   Keep build methods concise
-   Avoid business logic in widgets

------------------------------------------------------------------------

# 7. Riverpod Standards

-   One provider per responsibility
-   Providers expose immutable state
-   Business logic belongs in use cases
-   Avoid provider dependencies unless necessary
-   Dispose resources correctly

------------------------------------------------------------------------

# 8. Clean Architecture Rules

Allowed:

Presentation → Application → Domain → Data → Platform

Forbidden:

-   Widgets → Database
-   Widgets → Platform APIs
-   Domain → Flutter
-   Domain → Drift
-   Domain → Platform Channels

------------------------------------------------------------------------

# 9. Error Handling

-   Use typed failures
-   Catch infrastructure exceptions
-   Translate to domain failures
-   Display user-friendly messages
-   Log unexpected failures

------------------------------------------------------------------------

# 10. Documentation Standards

Public APIs should include documentation.

Complex algorithms require explanatory comments.

Comments must explain *why*, not *what*.

------------------------------------------------------------------------

# 11. Logging Standards

Logging should:

-   Be structured
-   Exclude sensitive information
-   Differentiate debug and release output
-   Aid diagnostics

------------------------------------------------------------------------

# 12. Testing Standards

Every feature should include:

-   Unit tests
-   Widget tests
-   Integration tests where appropriate
-   Regression tests for bug fixes

------------------------------------------------------------------------

# 13. Git Standards

Branches:

-   feature/\*
-   fix/\*
-   refactor/\*
-   docs/\*
-   chore/\*
-   test/\*

Commit prefixes:

-   feat:
-   fix:
-   refactor:
-   docs:
-   test:
-   chore:

------------------------------------------------------------------------

# 14. Performance Guidelines

-   Minimize widget rebuilds
-   Cache expensive computations
-   Lazy-load data
-   Profile before optimizing
-   Maintain smooth scrolling and animations

------------------------------------------------------------------------

# 15. Security Guidelines

-   Validate external input
-   Protect user data
-   Never commit secrets
-   Use least-privilege permissions
-   Sanitize imported metadata

------------------------------------------------------------------------

# 16. Accessibility

Support:

-   Screen readers
-   Semantic labels
-   Keyboard navigation
-   High contrast
-   Large text
-   Visible focus indicators

------------------------------------------------------------------------

# 17. Code Review Checklist

Before merging:

-   Builds successfully
-   Lints pass
-   Tests pass
-   Documentation updated
-   Architecture preserved
-   No dead code
-   No unnecessary dependencies

------------------------------------------------------------------------

# 18. Definition of Done

Code is complete when:

-   Requirements are implemented
-   Tests pass
-   Documentation is updated
-   Review checklist is satisfied
-   Coding standards are followed

------------------------------------------------------------------------

# 19. Future Improvements

-   Automated architecture linting
-   Security scanning
-   Static dependency validation
-   Performance dashboards
-   Documentation generation

------------------------------------------------------------------------

# 20. Acceptance Criteria

Coding standards are complete when:

-   Contributors follow a consistent style.
-   Architecture violations are minimized.
-   Code reviews become predictable.
-   The codebase remains maintainable as it grows.

------------------------------------------------------------------------

# Revision History

  -----------------------------------------------------------------------
  Version                Date            Description
  ---------------------- --------------- --------------------------------
  3.0.0                  Initial Draft   Expanded coding standards into
                                         an implementation-ready
                                         engineering standard with
                                         examples, architecture rules,
                                         review policies, and quality
                                         guidelines.

  -----------------------------------------------------------------------
