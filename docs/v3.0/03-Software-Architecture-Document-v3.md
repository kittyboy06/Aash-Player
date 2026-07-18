# 03-Software-Architecture-Document-v3.md

# Aash Player Software Architecture Document (v3.0)

**Version:** 3.0.0\
**Status:** Living Architecture Blueprint

------------------------------------------------------------------------

# Executive Summary

This document defines the implementation architecture of Aash Player. It
specifies architectural layers, package organization, dependency rules,
module responsibilities, sequence flows, state machines, and scalability
guidelines. It is the primary blueprint for implementing the
application.

------------------------------------------------------------------------

# 1. Architecture Goals

-   Maintainable
-   Scalable
-   Testable
-   Platform-independent business logic
-   High performance
-   Easy onboarding for contributors

------------------------------------------------------------------------

# 2. Architectural Style

-   Clean Architecture
-   Feature-first organization
-   Repository Pattern
-   MVVM-inspired presentation layer
-   Dependency Injection via Riverpod

------------------------------------------------------------------------

# 3. Layered Architecture

``` text
Presentation
    │
Application
    │
Domain
    │
Data
    │
Platform / Infrastructure
```

Dependencies always point inward.

------------------------------------------------------------------------

# 4. Package Structure

``` text
lib/
├── app/
├── core/
├── shared/
├── features/
│   ├── playback/
│   ├── library/
│   ├── playlists/
│   ├── metadata/
│   ├── search/
│   └── settings/
└── main.dart
```

Every feature contains:

-   presentation/
-   application/
-   domain/
-   data/

------------------------------------------------------------------------

# 5. Module Responsibilities

## Presentation

-   Widgets
-   Screens
-   Navigation
-   View models/providers

## Application

-   Use cases
-   Service orchestration

## Domain

-   Entities
-   Repository interfaces
-   Business rules

## Data

-   Repository implementations
-   Drift DAOs
-   Platform adapters

## Platform

-   Android integrations
-   Windows integrations
-   FFI wrappers

------------------------------------------------------------------------

# 6. Dependency Rules

Allowed:

Presentation → Application → Domain → Data → Platform

Forbidden:

-   Widgets → Database
-   Widgets → Platform APIs
-   Domain → Flutter
-   Domain → Drift
-   Domain → Platform Channels

------------------------------------------------------------------------

# 7. Navigation Architecture

``` text
AdaptiveShell
 ├ Home
 ├ Library
 ├ Albums
 ├ Artists
 ├ Playlists
 ├ Search
 ├ Settings
 └ Now Playing
```

Navigation state must survive configuration changes and desktop
resizing.

------------------------------------------------------------------------

# 8. Playback Sequence

``` text
User
 ↓
Play Button
 ↓
PlaybackController
 ↓
PlaySongUseCase
 ↓
PlayerRepository
 ↓
media_kit
 ↓
Audio Output
```

------------------------------------------------------------------------

# 9. Data Flow

``` text
UI
 ↓
Riverpod Provider
 ↓
Use Case
 ↓
Repository
 ↓
DAO / Platform Service
 ↓
Database / Native API
```

All data access passes through repositories.

------------------------------------------------------------------------

# 10. Playback State Machine

``` text
Idle
 ↓
Loading
 ↓
Playing
 ↙      ↘
Paused  Buffering
 ↓
Stopped
```

Transitions must be deterministic and observable.

------------------------------------------------------------------------

# 11. Error Flow

``` text
Platform Error
 ↓
Repository
 ↓
Domain Failure
 ↓
Provider State
 ↓
User-Friendly UI
```

Infrastructure errors must never leak directly to the UI.

------------------------------------------------------------------------

# 12. Scalability Strategy

Future modules:

-   Equalizer
-   DSP
-   Lyrics Sync
-   Cloud Backup
-   Plugin System

Each module should remain independently deployable within the
architecture.

------------------------------------------------------------------------

# 13. Architectural Governance

All architectural changes require:

-   ADR update
-   Documentation update
-   Tests
-   Review approval

------------------------------------------------------------------------

# 14. Quality Attributes

-   Performance
-   Reliability
-   Security
-   Maintainability
-   Extensibility
-   Accessibility

------------------------------------------------------------------------

# 15. Acceptance Criteria

Architecture documentation is complete when:

-   Layer responsibilities are explicit.
-   Dependency rules are enforceable.
-   Data and control flows are documented.
-   State machines are defined.
-   Future expansion does not require architectural redesign.

------------------------------------------------------------------------

# Revision History

  -----------------------------------------------------------------------
  Version                Date            Description
  ---------------------- --------------- --------------------------------
  3.0.0                  Initial Draft   Expanded software architecture
                                         into an implementation blueprint
                                         with package structure,
                                         dependency rules, sequence
                                         diagrams, state machines, and
                                         governance policies.

  -----------------------------------------------------------------------
