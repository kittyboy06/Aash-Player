# 03-Software-Architecture-Document-v2.md

# Aash Player Software Architecture Document (v2.0)

**Version:** 2.0.0\
**Status:** Living Document

------------------------------------------------------------------------

# Executive Summary

This document defines the complete software architecture for Aash
Player. It expands the v1.0 architecture by documenting architectural
layers, module boundaries, dependency rules, design patterns, sequence
flows, state management, scalability strategies, and architectural
governance.

------------------------------------------------------------------------

# 1. Architecture Goals

-   Maintain a single shared Flutter codebase
-   Isolate platform-specific implementations
-   Ensure modularity and scalability
-   Promote maintainability and testability
-   Preserve Clean Architecture principles

------------------------------------------------------------------------

# 2. Architectural Style

Primary Architecture:

-   Clean Architecture
-   Feature-first organization
-   Repository Pattern
-   Dependency Injection
-   Riverpod state management

Supporting Patterns:

-   MVVM-like presentation
-   Use Case pattern
-   Factory pattern
-   Adapter pattern
-   Strategy pattern

------------------------------------------------------------------------

# 3. High-Level Architecture

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

# 4. Layer Responsibilities

## Presentation

-   Widgets
-   Navigation
-   User interaction
-   Provider observation

## Application

-   Use cases
-   Controllers
-   Business orchestration

## Domain

-   Entities
-   Repository contracts
-   Business rules

## Data

-   Repository implementations
-   Drift DAOs
-   Local storage
-   Metadata adapters

## Platform

-   MediaStore
-   SMTC
-   Platform Channels
-   Native integrations

------------------------------------------------------------------------

# 5. Project Structure

``` text
lib/
├── app/
├── core/
├── shared/
├── features/
│   ├── playback/
│   ├── library/
│   ├── playlists/
│   ├── search/
│   ├── settings/
│   └── metadata/
└── main.dart
```

Each feature contains:

``` text
application/
data/
domain/
presentation/
```

------------------------------------------------------------------------

# 6. Dependency Rules

Allowed:

Presentation → Application

Application → Domain

Data → Domain

Platform → Data

Forbidden:

-   UI → Database
-   UI → Platform APIs
-   Domain → Flutter
-   Domain → Drift
-   Widgets → SQL

------------------------------------------------------------------------

# 7. State Management

Riverpod is the standard.

Responsibilities:

-   Providers expose immutable state
-   Controllers coordinate use cases
-   UI reacts to provider changes
-   Business logic remains outside widgets

------------------------------------------------------------------------

# 8. Navigation Architecture

-   Adaptive navigation shell
-   Bottom navigation (mobile)
-   Navigation rail (tablet)
-   Persistent sidebar (desktop)
-   Nested navigation where appropriate

------------------------------------------------------------------------

# 9. Playback Sequence

``` text
User
 ↓
UI
 ↓
Riverpod Controller
 ↓
PlaySongUseCase
 ↓
PlaybackRepository
 ↓
media_kit
 ↓
Native Audio Backend
```

------------------------------------------------------------------------

# 10. Data Flow

``` text
User Action
 ↓
Provider
 ↓
Use Case
 ↓
Repository
 ↓
Drift / Platform
 ↓
Updated State
 ↓
UI
```

------------------------------------------------------------------------

# 11. Error Flow

``` text
Platform Error
 ↓
Repository
 ↓
Domain Failure
 ↓
Provider
 ↓
User-Friendly UI Message
```

Unexpected failures should be logged without exposing sensitive data.

------------------------------------------------------------------------

# 12. Module Responsibilities

Core modules:

-   Playback
-   Library
-   Search
-   Metadata
-   Playlists
-   Backup
-   Settings
-   Theme

Modules should communicate only through public interfaces.

------------------------------------------------------------------------

# 13. Scalability Strategy

Future-ready architecture supports:

-   Plugin system
-   Additional platforms
-   Advanced DSP
-   Smart playlists
-   Optional cloud synchronization

------------------------------------------------------------------------

# 14. Architectural Governance

Major changes require:

-   Architecture Decision Record (ADR)
-   Design review
-   Documentation update
-   Migration plan (if applicable)

------------------------------------------------------------------------

# 15. Quality Attributes

The architecture should prioritize:

-   Performance
-   Reliability
-   Maintainability
-   Extensibility
-   Testability
-   Accessibility

------------------------------------------------------------------------

# 16. Acceptance Criteria

Architecture is considered successful when:

-   Dependency rules are respected.
-   Platform-specific code remains isolated.
-   Features are modular and independently testable.
-   Shared Flutter code remains the primary implementation.
-   Documentation stays synchronized with implementation.

------------------------------------------------------------------------

# Revision History

  -----------------------------------------------------------------------
  Version                Date            Description
  ---------------------- --------------- --------------------------------
  2.0.0                  Initial Draft   Expanded software architecture
                                         with layers, dependency rules,
                                         module boundaries, sequence
                                         flows, and governance.

  -----------------------------------------------------------------------
