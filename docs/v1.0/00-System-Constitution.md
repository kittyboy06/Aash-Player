# 00-System-Constitution.md

## Aash Player System Constitution

**Version:** 1.0.0\
**Status:** Draft\
**Classification:** Foundational Architecture Document\
**Applies To:** Entire Aash Player Project

------------------------------------------------------------------------

# Preface

This document is the **constitution of the Aash Player project**. It
defines the vision, principles, constraints, architectural philosophy,
engineering standards, and development rules that govern every aspect of
the software.

Unlike feature specifications or architecture documents, this
constitution is **timeless**. It is intended to remain stable throughout
the lifecycle of the project, serving as the highest authority for all
technical and design decisions.

Whenever conflicts arise between documentation, implementation, or
future enhancements, **this document takes precedence**.

------------------------------------------------------------------------

# 1. Vision

Aash Player aims to become a modern, intelligent, privacy-respecting,
cross-platform music player that combines the elegance of native
applications with the flexibility of Flutter.

The application is designed not merely to play music but to provide an
enjoyable and efficient environment for managing, organizing,
discovering, and experiencing personal music libraries across multiple
desktop and mobile platforms.

The project prioritizes ownership of local music rather than streaming
services, ensuring users maintain complete control over their media.

# 2. Mission

Develop a high-quality music player that:

-   Delivers smooth and reliable playback
-   Supports extensive music library management
-   Offers professional metadata editing
-   Adapts naturally to Android and Windows
-   Remains lightweight
-   Works offline
-   Maintains exceptional performance
-   Follows Clean Architecture
-   Remains maintainable for many years

# 3. Product Philosophy

## 3.1 Local First

-   Offline functionality is mandatory.
-   Cloud functionality is optional.
-   Local music is the primary focus.

## 3.2 User Ownership

Users fully own:

-   Music
-   Playlists
-   Metadata
-   Artwork
-   Lyrics
-   Backups

## 3.3 Privacy First

-   No unnecessary analytics
-   No advertising
-   No hidden telemetry
-   No user tracking

## 3.4 Platform Respect

Android and Windows should each receive an experience appropriate to
their platform rather than one mimicking the other.

## 3.5 Simplicity

Internal complexity should never become user complexity.

# 4. Project Goals

-   Exceptional playback quality
-   Fast library browsing
-   Beautiful adaptive UI
-   Professional metadata editing
-   Offline-first experience
-   Long-term maintainability

# 5. Non-Goals

-   Music streaming services
-   Social networking
-   DRM playback
-   Video playback
-   AI music generation
-   Audio production tools

# 6. Supported Platforms

-   Android
-   Windows

# 7. Official Technology Stack

  Layer                Technology
  -------------------- -------------------------
  Framework            Flutter
  Language             Dart
  State Management     Riverpod
  Database             Drift
  Playback             media_kit
  Metadata             audiotags
  Navigation           go_router
  Dynamic Color        palette_generator
  Background Audio     audio_service
  Native Integration   Platform Channels + FFI

# 8. Architecture Principles

The project adopts **Clean Architecture**.

Dependency Flow:

Presentation → Application → Domain → Data → Platform

Business logic must remain platform-independent.

# 9. Design Principles

-   Single Responsibility Principle
-   Separation of Concerns
-   Dependency Inversion
-   Composition over Inheritance
-   Immutable State

# 10. Cross-Platform Philosophy

Shared:

-   Business Logic
-   Playback Logic
-   UI Components
-   Repositories
-   Models
-   Navigation

Android-only examples:

-   MediaStore
-   Widgets
-   Lock Screen
-   Android AudioEffect APIs

Windows-only examples:

-   SMTC
-   Taskbar Integration
-   Native File Pickers
-   Keyboard-first Experience

# 11. Adaptive UI Principles

## Mobile

-   Bottom Navigation
-   Gesture-first
-   Single-column layout

## Desktop

-   Persistent Sidebar
-   Multi-pane layout
-   Keyboard shortcuts
-   Context menus

# 12. Code Quality Standards

Every contribution must be:

-   Readable
-   Maintainable
-   Testable
-   Modular
-   Documented

# 13. Mandatory Coding Rules

-   Never place business logic inside widgets.
-   Never execute SQL from UI.
-   Never bypass repositories or use cases.
-   Never duplicate business logic.

# 14. State Management

Riverpod is the single source of truth.

UI → Providers → Use Cases → Repositories → Data Sources

# 15. Error Handling

Errors must be:

-   Predictable
-   Recoverable where possible
-   Logged
-   User-friendly

# 16. Performance Goals

-   Fast startup
-   Smooth scrolling
-   Responsive playback
-   Efficient large-library handling

# 17. Accessibility

Support:

-   Screen readers
-   Keyboard navigation
-   Scalable text
-   High contrast
-   Touch accessibility

# 18. Security Principles

-   Least privilege permissions
-   Secure storage
-   Input validation
-   User privacy

# 19. Documentation Standards

Every feature requires documentation.

Every architectural change requires a documented decision.

# 20. Testing Philosophy

Required:

-   Unit Tests
-   Widget Tests
-   Integration Tests
-   Database Tests
-   Playback Tests
-   Platform Tests

# 21. AI Development Principles

AI-generated code must:

-   Follow Clean Architecture
-   Respect project conventions
-   Avoid duplication
-   Be maintainable
-   Include appropriate documentation

# 22. Governance

Architectural changes require a formal RFC/ADR before adoption.

# 23. Constitutional Rules

1.  Flutter is mandatory.
2.  Dart is the implementation language.
3.  Riverpod is the official state management solution.
4.  Clean Architecture is required.
5.  Business logic remains platform-independent.
6.  Offline-first design is preferred.
7.  Platform-specific code is minimized.
8.  User data belongs to the user.
9.  Documentation evolves with the project.
10. Maintainability is prioritized over shortcuts.

# 24. Closing Statement

This constitution establishes the guiding principles of Aash Player.
Every future document, feature, implementation, and architectural
decision should align with these principles to ensure a cohesive,
scalable, and maintainable product.
