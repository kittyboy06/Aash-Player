# 00-System-Constitution-v3.md

# Aash Player System Constitution (v3.0)

**Version:** 3.0.0\
**Status:** Living Engineering Constitution

------------------------------------------------------------------------

# Executive Summary

This constitution defines the immutable engineering principles governing
Aash Player. It serves as the highest authority for architecture,
technology choices, governance, performance, security, documentation,
and AI-assisted development. All implementation decisions must comply
with this document.

------------------------------------------------------------------------

# 1. Vision

Build a fast, modern, privacy-first music player that provides a native
experience on Android and Windows while sharing a single Flutter
codebase.

------------------------------------------------------------------------

# 2. Mission

-   Deliver a delightful offline music experience.
-   Share as much code as practical.
-   Keep architecture clean and maintainable.
-   Prioritize reliability, accessibility, and performance.

------------------------------------------------------------------------

# 3. Core Values

-   User-first design
-   Simplicity over complexity
-   Privacy by default
-   Testability
-   Consistency
-   Long-term maintainability

------------------------------------------------------------------------

# 4. Engineering Principles

-   Clean Architecture is mandatory.
-   Dependencies always point inward.
-   Business logic is platform-independent.
-   Feature-first organization.
-   Prefer composition over inheritance.
-   Prefer immutable models.

------------------------------------------------------------------------

# 5. Technology Constitution

  Layer              Technology
  ------------------ -------------------
  UI                 Flutter
  Language           Dart
  State Management   Riverpod
  Database           Drift + SQLite
  Playback           media_kit
  Metadata           audiotags
  Platforms          Android & Windows

Technology changes require an Architecture Decision Record (ADR).

------------------------------------------------------------------------

# 6. Architecture Decision Records (ADR)

Every significant decision must include:

-   Identifier
-   Context
-   Alternatives Considered
-   Decision
-   Rationale
-   Consequences

Example:

``` text
ADR-001
Decision: Riverpod
Reason: Compile-time safety, testability, scalability.
```

------------------------------------------------------------------------

# 7. Governance Rules

The following are non-negotiable:

-   Widgets must never access the database directly.
-   Domain must not depend on Flutter.
-   Platform APIs are isolated behind interfaces.
-   All new features require tests.
-   Documentation must accompany architectural changes.

------------------------------------------------------------------------

# 8. Performance Budgets

  Metric                Target
  ---------------- -----------
  Cold Start            \< 2 s
  Playback Start     \< 100 ms
  Search             \< 150 ms
  Library Scan          \< 3 s
  UI                    60 FPS

Performance regressions should block release until reviewed.

------------------------------------------------------------------------

# 9. Security Principles

-   Least-privilege permissions
-   No secrets in source control
-   Validate external inputs
-   Protect user data
-   Keep processing local where possible

------------------------------------------------------------------------

# 10. AI Collaboration Rules

AI assistants must:

-   Follow this constitution.
-   Respect architectural boundaries.
-   Generate tests with features.
-   Update documentation.
-   Explain assumptions.
-   Never bypass established patterns.

------------------------------------------------------------------------

# 11. Documentation Standards

Documentation must be:

-   Version controlled
-   Updated alongside code
-   Traceable to implementation
-   Clear and concise

------------------------------------------------------------------------

# 12. Version Compatibility

Major versions may introduce breaking changes.

Minor versions add backward-compatible features.

Patch versions contain fixes only.

------------------------------------------------------------------------

# 13. Deprecation Policy

Deprecated APIs must:

-   Be documented
-   Include migration guidance
-   Remain available for at least one minor release where feasible

------------------------------------------------------------------------

# 14. Long-Term Roadmap

-   Linux support
-   macOS support
-   Plugin ecosystem
-   DSP enhancements
-   Cloud backup (optional)
-   Multi-device synchronization

------------------------------------------------------------------------

# 15. Constitutional Rules

No implementation may violate this document without an approved ADR.

This constitution supersedes all lower-level documentation when
conflicts arise.

------------------------------------------------------------------------

# Revision History

  -----------------------------------------------------------------------
  Version                Date            Description
  ---------------------- --------------- --------------------------------
  3.0.0                  Initial Draft   Introduced governance, ADRs,
                                         performance budgets, security
                                         principles, AI collaboration
                                         rules, and constitutional
                                         policies for implementation.

  -----------------------------------------------------------------------
