# 00-System-Constitution-v2.md

# Aash Player System Constitution (v2.0)

**Version:** 2.0.0\
**Status:** Living Document

------------------------------------------------------------------------

# Executive Summary

This constitution is the highest-level governing document for Aash
Player. It establishes the vision, engineering philosophy, architectural
principles, decision-making process, and long-term direction of the
project. Every design, implementation, and release decision should align
with this constitution.

------------------------------------------------------------------------

# 1. Vision

Build a modern, privacy-first, local-first music player that provides a
native-quality experience across Android and Windows while sharing a
single, maintainable Flutter codebase.

------------------------------------------------------------------------

# 2. Mission

-   Deliver a fast and beautiful music player.
-   Prioritize user ownership of data.
-   Minimize platform-specific code.
-   Maintain long-term architectural stability.

------------------------------------------------------------------------

# 3. Core Values

-   Privacy First
-   Local First
-   User Ownership
-   Accessibility by Design
-   Simplicity over Complexity
-   Performance Matters
-   Consistency Across Platforms

------------------------------------------------------------------------

# 4. Product Philosophy

The application should:

-   Never depend on cloud services for core functionality.
-   Keep user data under user control.
-   Adapt to each platform instead of forcing identical interfaces.
-   Prefer stability over unnecessary features.

------------------------------------------------------------------------

# 5. Engineering Principles

-   Clean Architecture
-   SOLID Principles
-   Feature-first organization
-   Dependency inversion
-   Composition over inheritance
-   Immutable data where practical

------------------------------------------------------------------------

# 6. Architecture Decision Records (ADR)

Major technical decisions must be documented with:

-   Context
-   Decision
-   Alternatives Considered
-   Consequences
-   Status
-   Date

No significant architectural change should be made without an ADR.

------------------------------------------------------------------------

# 7. Technology Constitution

Approved stack:

-   Flutter
-   Dart
-   Riverpod
-   Drift
-   media_kit
-   audiotags
-   Material 3

Technology changes require architectural review.

------------------------------------------------------------------------

# 8. Cross-Platform Policy

Shared responsibilities:

-   UI logic
-   Business logic
-   Database
-   Playback orchestration
-   Navigation
-   Settings
-   Backup

Platform-specific responsibilities:

Android: - MediaStore - Audio Focus - Widgets - Notifications

Windows: - SMTC - Native file picker - Taskbar integration - Desktop
shortcuts

------------------------------------------------------------------------

# 9. Performance Budgets

Targets:

-   Cold start under 2 seconds (typical device)
-   Smooth 60 FPS interactions
-   Efficient scrolling for large libraries
-   Low idle memory usage
-   Responsive playback controls

Performance regressions should be investigated before release.

------------------------------------------------------------------------

# 10. Security & Privacy

-   Least-privilege permissions
-   No unnecessary telemetry
-   Secure local storage
-   Validate external inputs
-   Never expose sensitive information in logs

------------------------------------------------------------------------

# 11. AI Collaboration Principles

AI assistants should:

-   Respect this constitution.
-   Follow architecture before implementation.
-   Explain assumptions.
-   Avoid introducing unnecessary dependencies.
-   Update documentation alongside code.

------------------------------------------------------------------------

# 12. Documentation Standards

Documentation should be:

-   Version-controlled
-   Kept current
-   Written in Markdown
-   Reviewed with architectural changes
-   Treated as part of the product

------------------------------------------------------------------------

# 13. Governance

Roles:

-   Maintainer
-   Contributor
-   Reviewer

Architectural changes require review and documented rationale.

------------------------------------------------------------------------

# 14. Version Compatibility

-   Follow Semantic Versioning.
-   Preserve backward compatibility where practical.
-   Document breaking changes clearly.

------------------------------------------------------------------------

# 15. Deprecation Policy

Deprecated features must include:

-   Reason
-   Replacement
-   Removal timeline
-   Migration guidance

------------------------------------------------------------------------

# 16. Long-Term Roadmap

Future focus areas:

-   Plugin ecosystem
-   Advanced DSP
-   Cross-device sync (optional)
-   Desktop enhancements
-   Expanded accessibility

------------------------------------------------------------------------

# 17. Constitutional Rules

-   Architecture takes precedence over convenience.
-   Shared code is preferred whenever feasible.
-   Platform code must remain isolated.
-   Every feature requires documentation and testing.
-   Quality is never optional.

------------------------------------------------------------------------

# Revision History

  -----------------------------------------------------------------------
  Version                Date            Description
  ---------------------- --------------- --------------------------------
  2.0.0                  Initial Draft   Expanded constitutional document
                                         with governance, ADRs,
                                         performance, security, AI
                                         collaboration, and roadmap.

  -----------------------------------------------------------------------
