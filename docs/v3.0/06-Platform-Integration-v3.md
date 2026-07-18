# 06-Platform-Integration-v3.md

# Aash Player Platform Integration (v3.0)

**Version:** 3.0.0\
**Status:** Living Platform Blueprint

------------------------------------------------------------------------

# Executive Summary

This document defines the implementation blueprint for platform
integration in Aash Player. It specifies how the shared Flutter
application communicates with Android and Windows services while
preserving Clean Architecture and maximizing code sharing.

------------------------------------------------------------------------

# 1. Objectives

-   Keep business logic platform-independent
-   Isolate native functionality
-   Maintain feature parity
-   Preserve native user experience
-   Support future platform expansion

------------------------------------------------------------------------

# 2. Platform Architecture

``` text
Flutter UI
    │
Riverpod Providers
    │
Use Cases
    │
Repositories
    │
Platform Service Interfaces
    │
────────────────────────
│ Platform Channels    │
│ FFI Wrappers         │
────────────────────────
    │
Android / Windows APIs
```

Shared code must never directly invoke native APIs.

------------------------------------------------------------------------

# 3. Shared Responsibilities

The shared layer owns:

-   UI
-   Navigation
-   Business logic
-   Playback orchestration
-   Drift database
-   Metadata editing
-   Backup & restore
-   Theme management

------------------------------------------------------------------------

# 4. Android Integration

Responsibilities:

-   MediaStore scanning
-   Runtime permissions
-   Audio Focus
-   Foreground Service
-   Notifications
-   Lock screen controls
-   Bluetooth media keys
-   Home screen widgets (future)

Lifecycle:

1.  Initialize services
2.  Request permissions
3.  Scan MediaStore
4.  Register media session
5.  Start foreground service
6.  Dispose resources

------------------------------------------------------------------------

# 5. Windows Integration

Responsibilities:

-   System Media Transport Controls (SMTC)
-   Native file picker
-   Drag & drop
-   Context menus
-   Keyboard shortcuts
-   Taskbar integration
-   System tray (future)

Lifecycle:

1.  Initialize desktop services
2.  Register SMTC
3.  Restore library
4.  Handle hardware media keys
5.  Release resources on exit

------------------------------------------------------------------------

# 6. Platform Channel Contracts

Each channel must define:

-   Method name
-   Parameters
-   Return type
-   Error codes
-   Version
-   Backward compatibility

Example:

``` text
getMediaLibrary()
→ List<MediaItem>

requestPermission(type)
→ PermissionStatus
```

------------------------------------------------------------------------

# 7. FFI Integration

FFI is reserved for:

-   audiotags (TagLib)
-   Native DSP modules
-   Performance-critical libraries

Guidelines:

-   Thin wrappers
-   Clear ownership
-   Explicit memory management
-   Exception translation

------------------------------------------------------------------------

# 8. Permission Strategy

Android:

-   Audio/media access
-   Notifications (where applicable)

Windows:

-   User-selected folders
-   Local filesystem access

Principles:

-   Least privilege
-   Explain permission purpose
-   Graceful denial handling

------------------------------------------------------------------------

# 9. Error Flow

``` text
Native Failure
      │
Platform Adapter
      │
Repository
      │
Domain Failure
      │
Riverpod State
      │
UI Feedback
```

Platform-specific exceptions must never escape into the presentation
layer.

------------------------------------------------------------------------

# 10. Performance

Targets:

-   Minimize channel calls
-   Cache platform information
-   Reuse native resources
-   Non-blocking UI
-   Lazy initialization

------------------------------------------------------------------------

# 11. Security

-   Validate channel inputs
-   Sanitize native responses
-   Protect local files
-   Never expose secrets through channels
-   Restrict FFI surface area

------------------------------------------------------------------------

# 12. Testing

Required:

-   Platform channel tests
-   Android integration tests
-   Windows integration tests
-   Permission flow tests
-   SMTC tests
-   Media session tests
-   FFI wrapper tests

------------------------------------------------------------------------

# 13. Future Platform Support

Planned:

-   Linux
-   macOS

Requirements:

-   Shared interfaces
-   Platform adapters
-   Independent integration tests

------------------------------------------------------------------------

# 14. Acceptance Criteria

Platform integration is complete when:

-   Shared code remains platform-agnostic.
-   Native functionality is isolated behind interfaces.
-   Android and Windows behave as first-class platforms.
-   Platform contracts are documented and testable.
-   New platforms can be added without architectural redesign.

------------------------------------------------------------------------

# Revision History

  -----------------------------------------------------------------------
  Version                Date            Description
  ---------------------- --------------- --------------------------------
  3.0.0                  Initial Draft   Expanded platform integration
                                         into an implementation blueprint
                                         with lifecycle definitions,
                                         platform contracts, FFI
                                         strategy, permission model,
                                         testing, and future platform
                                         support.

  -----------------------------------------------------------------------
