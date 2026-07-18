# 06-Platform-Integration-v2.md

# Aash Player Platform Integration Specification (v2.0)

**Version:** 2.0.0\
**Status:** Living Document

------------------------------------------------------------------------

# Executive Summary

This document defines the platform-specific architecture for Aash
Player. It explains how Android and Windows integrate with the shared
Flutter application while preserving Clean Architecture. Native
functionality is isolated behind interfaces, Platform Channels, and FFI
boundaries to maximize shared code and maintainability.

------------------------------------------------------------------------

# 1. Objectives

-   Maximize shared Flutter implementation
-   Isolate native integrations
-   Preserve platform-native behavior
-   Maintain testability
-   Support future platform expansion

------------------------------------------------------------------------

# 2. Platform Strategy

## Shared Layer

Shared responsibilities include:

-   UI
-   Riverpod state management
-   Business logic
-   Drift database
-   Playback orchestration
-   Metadata editing
-   Theme management
-   Backup & Restore

## Native Layer

Platform-specific responsibilities include:

Android: - MediaStore - Audio Focus - Notifications - Foreground
Service - Widgets - Permission handling

Windows: - SMTC - Native file picker - Keyboard shortcuts - Context
menus - Taskbar integration

------------------------------------------------------------------------

# 3. Integration Architecture

``` text
Flutter UI
    │
Application Layer
    │
Repository
    │
Platform Service Interface
    │
───────────────
│ Platform Channel │
│       FFI        │
───────────────
    │
Native APIs / Libraries
```

Business logic must never directly reference native APIs.

------------------------------------------------------------------------

# 4. Android Integration

## MediaStore

-   Initial scan
-   Incremental updates
-   Metadata synchronization
-   Content observer support

## Audio Focus

Handle:

-   Calls
-   Navigation prompts
-   Other audio apps
-   Headphone disconnect

## Foreground Service

Responsibilities:

-   Background playback
-   Persistent notification
-   Media session lifecycle

## Notifications

Support:

-   Play/Pause
-   Previous
-   Next
-   Seek
-   Artwork
-   Metadata

## Widgets (Future)

-   Mini player
-   Recently played
-   Playlist shortcuts

------------------------------------------------------------------------

# 5. Windows Integration

## System Media Transport Controls

Provide:

-   Playback state
-   Metadata
-   Artwork
-   Hardware media key support

## Native File Picker

Support:

-   Folder selection
-   Multi-file import
-   Backup selection

## Desktop Features

-   Context menus
-   Drag & drop
-   Keyboard shortcuts
-   Future system tray support

------------------------------------------------------------------------

# 6. Platform Channels

Use Platform Channels for:

-   Permission requests
-   Notifications
-   Media session events
-   Native settings
-   OS-specific features

Contracts should be versioned and documented.

------------------------------------------------------------------------

# 7. FFI Integration

FFI is used for:

-   audiotags / TagLib
-   Native DSP libraries (future)
-   Performance-critical extensions

Keep FFI wrappers thin and isolated.

------------------------------------------------------------------------

# 8. Platform Lifecycle

Typical lifecycle:

1.  App launch
2.  Platform service initialization
3.  Permission checks
4.  Native resource allocation
5.  Runtime event handling
6.  Resource cleanup on exit

------------------------------------------------------------------------

# 9. Error Handling

Platform failures should:

-   Translate into domain failures
-   Avoid crashing shared code
-   Provide actionable logs
-   Display user-friendly messages

------------------------------------------------------------------------

# 10. Security

-   Least-privilege permissions
-   Validate native responses
-   Protect local files
-   Never expose secrets through channels

------------------------------------------------------------------------

# 11. Performance

-   Minimize Platform Channel traffic
-   Cache repeated platform queries
-   Reuse native resources
-   Avoid blocking UI thread

------------------------------------------------------------------------

# 12. Testing

Required:

-   Platform Channel tests
-   Android integration tests
-   Windows integration tests
-   Permission flow tests
-   Media session tests
-   FFI wrapper tests

------------------------------------------------------------------------

# 13. Future Enhancements

-   Linux support
-   macOS support
-   Plugin architecture
-   Auto-update integration
-   Desktop tray application

------------------------------------------------------------------------

# 14. Acceptance Criteria

Platform integration is complete when:

-   Shared Flutter code remains the primary implementation.
-   Native functionality is isolated behind interfaces.
-   Android and Windows behave as native applications.
-   Platform integrations are fully testable.
-   Documentation matches implementation.

------------------------------------------------------------------------

# Revision History

  -----------------------------------------------------------------------
  Version                Date            Description
  ---------------------- --------------- --------------------------------
  2.0.0                  Initial Draft   Expanded platform integration
                                         with lifecycle, platform
                                         channels, FFI boundaries, native
                                         architecture, and testing
                                         strategy.

  -----------------------------------------------------------------------
