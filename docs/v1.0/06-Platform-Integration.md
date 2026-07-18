# 06-Platform-Integration.md

# Aash Player Platform Integration Specification

**Version:** 1.0.0\
**Status:** Draft

------------------------------------------------------------------------

# Executive Summary

This document defines the platform-specific integration strategy for
Aash Player. While the majority of the application is implemented in
Flutter using shared business logic, certain capabilities require native
implementations on Android and Windows. These integrations are isolated
behind Platform Channels and FFI to preserve Clean Architecture and
maximize code reuse.

------------------------------------------------------------------------

# 1. Objectives

-   Maximize shared Flutter code
-   Isolate platform-specific logic
-   Preserve Clean Architecture
-   Provide a native user experience
-   Ensure maintainability

------------------------------------------------------------------------

# 2. Platform Strategy

## Shared Flutter Layer

Shared responsibilities include:

-   UI
-   Business logic
-   Riverpod providers
-   Drift database
-   Playback orchestration
-   Navigation
-   Theme management
-   Metadata editing
-   Backup and restore

## Native Platform Layer

Native implementations are only introduced when Flutter cannot provide
the required capability.

------------------------------------------------------------------------

# 3. Integration Technologies

  Component              Technology
  ---------------------- --------------------------
  Cross-platform UI      Flutter
  Native Communication   Platform Channels
  Native Libraries       FFI
  Android Language       Kotlin
  Windows Language       C++ / C# (when required)

------------------------------------------------------------------------

# 4. Android Integration

## MediaStore

Responsibilities:

-   Scan local audio files
-   Detect library changes
-   Read media metadata
-   Observe media updates

------------------------------------------------------------------------

## Permissions

Required permissions:

-   Media access
-   Notifications
-   Foreground service (playback)

Permission requests should be contextual and minimal.

------------------------------------------------------------------------

## Notifications

Features:

-   Playback controls
-   Album artwork
-   Progress
-   Media session integration

------------------------------------------------------------------------

## Lock Screen

Provide:

-   Playback controls
-   Song metadata
-   Artwork
-   Seek controls (where supported)

------------------------------------------------------------------------

## Home Screen Widgets

Future support:

-   Mini player widget
-   Playlist shortcuts
-   Recently played widget

------------------------------------------------------------------------

## Audio Focus

Handle:

-   Incoming calls
-   Navigation prompts
-   Audio interruptions
-   Bluetooth device changes

------------------------------------------------------------------------

# 5. Windows Integration

## System Media Transport Controls (SMTC)

Support:

-   Play
-   Pause
-   Next
-   Previous
-   Seek
-   Metadata
-   Artwork

------------------------------------------------------------------------

## File Picker

Provide native folder and file selection for importing music libraries.

------------------------------------------------------------------------

## Taskbar Integration

Potential future features:

-   Thumbnail toolbar
-   Progress indicator
-   Playback controls

------------------------------------------------------------------------

## Keyboard Shortcuts

Examples:

-   Space: Play/Pause
-   Ctrl+F: Search
-   Ctrl+P: Playlists
-   Ctrl+,: Settings

------------------------------------------------------------------------

## Context Menus

Desktop-only context menus for:

-   Songs
-   Albums
-   Artists
-   Playlists

------------------------------------------------------------------------

# 6. Platform Channels

Platform Channels are used for:

-   Permission handling
-   Native playback controls
-   System integrations
-   Platform-specific settings

Flutter communicates only through well-defined service interfaces.

------------------------------------------------------------------------

# 7. FFI Usage

FFI is used when direct access to native libraries is required.

Examples:

-   TagLib (via audiotags)
-   Native DSP libraries (future)
-   Performance-critical native extensions

------------------------------------------------------------------------

# 8. Shared Feature Matrix

  Feature                 Shared   Android   Windows
  ---------------------- -------- --------- ---------
  Playback                  ✓         ✓         ✓
  Library                   ✓         ✓         ✓
  Metadata Editing          ✓         ✓         ✓
  Adaptive UI               ✓         ✓         ✓
  Dynamic Theme             ✓         ✓         ✓
  Notifications             ✓         ✓         ✓
  Lock Screen Controls      \-        ✓        \-
  Home Screen Widgets       \-        ✓        \-
  MediaStore                \-        ✓        \-
  SMTC                      \-       \-         ✓
  Taskbar Controls          \-       \-         ✓

------------------------------------------------------------------------

# 9. Platform Isolation Rules

-   Shared code must not import native APIs directly.
-   Platform-specific implementations remain behind interfaces.
-   Business logic must remain platform-independent.
-   Native code should be minimal and replaceable.

------------------------------------------------------------------------

# 10. Error Handling

Platform integrations must:

-   Return predictable results
-   Translate native exceptions into domain-friendly errors
-   Log failures
-   Avoid crashing shared code

------------------------------------------------------------------------

# 11. Security

-   Request only necessary permissions
-   Validate platform responses
-   Protect user privacy
-   Avoid exposing sensitive file paths unnecessarily

------------------------------------------------------------------------

# 12. Performance Guidelines

-   Minimize platform channel calls
-   Batch operations where possible
-   Cache frequently requested platform data
-   Avoid blocking the UI thread

------------------------------------------------------------------------

# 13. Testing

Required:

-   Platform channel tests
-   Native integration tests
-   Permission handling tests
-   MediaStore tests
-   SMTC tests
-   File picker tests

------------------------------------------------------------------------

# 14. Future Enhancements

-   Desktop mini-player
-   Global media hotkeys
-   System tray integration
-   Advanced widget support
-   Plugin-based platform extensions

------------------------------------------------------------------------

# 15. Acceptance Criteria

Platform integration is successful when:

-   Shared Flutter code remains the primary implementation.
-   Android and Windows features feel native.
-   Platform-specific logic is isolated.
-   Native integrations do not violate Clean Architecture.
-   Platform APIs are abstracted behind interfaces.

------------------------------------------------------------------------

# Revision History

  Version   Date            Description
  --------- --------------- --------------------------------------------
  1.0.0     Initial Draft   Initial Platform Integration Specification
