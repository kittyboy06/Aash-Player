# 03-Software-Architecture-Document.md

# Aash Player Software Architecture Document (SAD)

**Version:** 1.0.0\
**Status:** Draft

------------------------------------------------------------------------

# Executive Summary

This document defines the software architecture of Aash Player. It
describes the structural design, architectural principles, technology
stack, module decomposition, dependency rules, and communication flow
required to build a scalable, maintainable, and cross-platform music
player using Flutter.

------------------------------------------------------------------------

# 1. Architectural Goals

-   Scalability
-   Maintainability
-   Testability
-   Platform independence
-   Offline-first operation
-   High performance
-   Modular development

------------------------------------------------------------------------

# 2. Architecture Overview

Aash Player follows **Clean Architecture**.

    Presentation
          │
    Application
          │
    Domain
          │
    Data
          │
    Platform

Dependencies always point inward.

------------------------------------------------------------------------

# 3. Technology Stack

  Layer                Technology
  -------------------- -------------------------
  Framework            Flutter
  Language             Dart
  State Management     Riverpod
  Database             Drift
  Audio Engine         media_kit
  Metadata             audiotags
  Navigation           go_router
  Background Audio     audio_service
  Native Integration   Platform Channels + FFI

------------------------------------------------------------------------

# 4. Architectural Principles

-   Clean Architecture
-   SOLID Principles
-   Repository Pattern
-   Dependency Inversion
-   Feature-first organization
-   Immutable state where practical
-   Separation of concerns

------------------------------------------------------------------------

# 5. Layer Responsibilities

## Presentation Layer

Responsibilities:

-   UI
-   Navigation
-   Widgets
-   User interaction
-   Provider consumption

Must not contain business logic.

------------------------------------------------------------------------

## Application Layer

Responsibilities:

-   Use Cases
-   Business orchestration
-   Validation
-   Feature workflows

------------------------------------------------------------------------

## Domain Layer

Contains:

-   Entities
-   Repository interfaces
-   Value objects
-   Business rules

Must remain platform-independent.

------------------------------------------------------------------------

## Data Layer

Contains:

-   Repository implementations
-   Drift DAOs
-   Local storage
-   Metadata services
-   Playback services

------------------------------------------------------------------------

## Platform Layer

Contains:

-   Android integrations
-   Windows integrations
-   Platform channels
-   FFI bindings
-   Native APIs

------------------------------------------------------------------------

# 6. Feature-Based Project Structure

    lib/
    │
    ├── app/
    ├── core/
    ├── features/
    │   ├── library/
    │   ├── playback/
    │   ├── playlists/
    │   ├── search/
    │   ├── metadata/
    │   ├── settings/
    │   ├── backup/
    │   └── onboarding/
    │
    └── shared/

------------------------------------------------------------------------

# 7. Core Modules

-   Playback
-   Library
-   Metadata
-   Search
-   Playlists
-   Backup
-   Settings
-   Theme
-   Platform

------------------------------------------------------------------------

# 8. State Management

Riverpod is the single source of truth.

Flow:

    UI
     ↓
    Provider
     ↓
    Use Case
     ↓
    Repository
     ↓
    Data Source

------------------------------------------------------------------------

# 9. Repository Pattern

Repositories expose domain interfaces.

Example:

-   SongRepository
-   PlaylistRepository
-   MetadataRepository
-   PlaybackRepository

UI never communicates directly with storage.

------------------------------------------------------------------------

# 10. Dependency Rules

Allowed:

Presentation → Application

Application → Domain

Data → Domain

Platform → Data

Forbidden:

-   UI → Database
-   UI → Platform APIs
-   Presentation → Drift
-   Widgets → SQL

------------------------------------------------------------------------

# 11. Navigation Architecture

Navigation uses **go_router**.

Adaptive shell:

Mobile: - Bottom Navigation

Desktop: - Sidebar - Navigation Rail - Multi-pane layout

------------------------------------------------------------------------

# 12. Playback Architecture

Playback engine:

-   media_kit
-   Queue Manager
-   Playback Controller
-   Audio Session
-   Background Playback
-   Notifications

------------------------------------------------------------------------

# 13. Metadata Architecture

Metadata handled using **audiotags**.

Supports:

-   Title
-   Artist
-   Album
-   Genre
-   Lyrics
-   Artwork

------------------------------------------------------------------------

# 14. Database Architecture

Persistence uses **Drift**.

Stores:

-   Songs
-   Albums
-   Artists
-   Playlists
-   Queue
-   Favorites
-   Settings

------------------------------------------------------------------------

# 15. Theme Architecture

Supports:

-   Material 3
-   Dynamic color
-   Artwork-derived accents
-   Light/Dark mode

------------------------------------------------------------------------

# 16. Platform Architecture

## Shared

-   Business logic
-   Models
-   Providers
-   Repositories
-   UI components

## Android

-   MediaStore
-   Widgets
-   Notifications
-   AudioEffect APIs (where applicable)

## Windows

-   SMTC
-   Native file pickers
-   Keyboard shortcuts
-   Taskbar integration

------------------------------------------------------------------------

# 17. Error Handling

Errors flow upward.

Platform → Data → Domain → UI

Every error should be:

-   Logged
-   Recoverable where possible
-   User-friendly

------------------------------------------------------------------------

# 18. Logging Strategy

Log categories:

-   Playback
-   Database
-   Metadata
-   Navigation
-   Platform
-   Performance

------------------------------------------------------------------------

# 19. Testing Strategy

Required:

-   Unit Tests
-   Widget Tests
-   Integration Tests
-   Repository Tests
-   Database Tests
-   Playback Tests

------------------------------------------------------------------------

# 20. Security Considerations

-   Least privilege permissions
-   Input validation
-   Secure preference storage
-   User privacy
-   Offline-first design

------------------------------------------------------------------------

# 21. Scalability

Architecture must support:

-   New platforms
-   Plugin architecture
-   Additional playback features
-   Future cloud synchronization
-   Modular feature additions

------------------------------------------------------------------------

# 22. Architectural Decision Records (ADR)

Major architectural changes require:

-   Problem statement
-   Alternatives considered
-   Decision
-   Trade-offs
-   Consequences

------------------------------------------------------------------------

# 23. Acceptance Criteria

The architecture is considered successful when:

-   Business logic is platform-independent.
-   Shared code is maximized.
-   Flutter drives the UI on Android and Windows.
-   Platform-specific implementations remain isolated.
-   Every feature follows Clean Architecture.

------------------------------------------------------------------------

# Revision History

  Version   Date            Description
  --------- --------------- ----------------------------------------
  1.0.0     Initial Draft   Initial Software Architecture Document
