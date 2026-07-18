# 05-Playback-Architecture.md

# Aash Player Playback Architecture

**Version:** 1.0.0\
**Status:** Draft

------------------------------------------------------------------------

# Executive Summary

This document defines the playback subsystem for Aash Player. It
specifies the architecture, playback pipeline, queue management, audio
session handling, metadata integration, and platform-specific playback
behavior. The playback engine is built around **media_kit** (libmpv) to
provide consistent, high-quality audio playback across Android and
Windows.

------------------------------------------------------------------------

# 1. Objectives

-   High-performance audio playback
-   Cross-platform consistency
-   Offline-first operation
-   Stable background playback
-   Extensible audio pipeline
-   Low-latency controls

------------------------------------------------------------------------

# 2. Technology Stack

  Component              Technology
  ---------------------- -------------------------
  Playback Engine        media_kit
  Backend                libmpv
  Background Audio       audio_service
  Metadata               audiotags
  State Management       Riverpod
  Platform Integration   Platform Channels + FFI

------------------------------------------------------------------------

# 3. Playback Pipeline

``` text
User Action
     │
     ▼
Playback Provider
     │
     ▼
Playback Use Case
     │
     ▼
Playback Repository
     │
     ▼
media_kit Player
     │
     ▼
libmpv Backend
     │
     ▼
Operating System Audio Output
```

------------------------------------------------------------------------

# 4. Core Components

-   Playback Controller
-   Queue Manager
-   Playlist Resolver
-   Audio Session Manager
-   Metadata Loader
-   Lyrics Manager
-   Artwork Manager
-   Notification Manager
-   Position Tracker

------------------------------------------------------------------------

# 5. Playback States

-   Idle
-   Loading
-   Ready
-   Playing
-   Paused
-   Buffering
-   Completed
-   Error
-   Stopped

Transitions must be deterministic and observable through Riverpod
providers.

------------------------------------------------------------------------

# 6. Queue Architecture

Queue supports:

-   Play Next
-   Add to Queue
-   Remove
-   Reorder
-   Clear Queue
-   Repeat Queue
-   Repeat Track
-   Shuffle Queue
-   Resume Queue

Queue persists between application launches.

------------------------------------------------------------------------

# 7. Playback Controls

Supported actions:

-   Play
-   Pause
-   Stop
-   Next
-   Previous
-   Seek
-   Fast Forward
-   Rewind
-   Shuffle
-   Repeat
-   Volume
-   Mute

------------------------------------------------------------------------

# 8. Background Playback

Background playback must support:

-   Notification controls
-   Headset media buttons
-   Bluetooth controls
-   Resume after interruption
-   Persistent playback state

------------------------------------------------------------------------

# 9. Metadata Integration

Metadata is loaded using **audiotags**.

Displayed information:

-   Title
-   Artist
-   Album
-   Genre
-   Duration
-   Bitrate
-   Sample Rate
-   Artwork
-   Lyrics

Metadata updates should refresh the UI without restarting playback.

------------------------------------------------------------------------

# 10. Lyrics

Supported types:

-   Embedded lyrics
-   Unsynchronized lyrics
-   Time-synchronized lyrics (future)

Lyrics are associated with the current playback position.

------------------------------------------------------------------------

# 11. Artwork Handling

Artwork sources:

-   Embedded artwork
-   External artwork files
-   Cached artwork

Artwork should be cached for smooth scrolling and fast loading.

------------------------------------------------------------------------

# 12. Equalizer Strategy

Android: - Platform-specific implementation using native audio
capabilities where appropriate.

Windows: - DSP implementation or libmpv filter chain (future
enhancement).

Shared: - Equalizer profiles - Preset management - User presets

------------------------------------------------------------------------

# 13. Platform Integration

## Android

-   Audio focus
-   Headset controls
-   Notifications
-   Lock screen controls
-   Bluetooth media buttons

## Windows

-   System Media Transport Controls (SMTC)
-   Media key support
-   Taskbar media integration

------------------------------------------------------------------------

# 14. Error Handling

Possible playback errors:

-   Missing file
-   Unsupported format
-   Corrupt media
-   Permission denied
-   Device unavailable

Errors must provide meaningful feedback and allow graceful recovery.

------------------------------------------------------------------------

# 15. Performance Guidelines

-   Lazy metadata loading
-   Preload next track
-   Efficient queue updates
-   Artwork caching
-   Minimal UI rebuilds

------------------------------------------------------------------------

# 16. Testing Strategy

Required tests:

-   Playback controller
-   Queue manager
-   Repeat modes
-   Shuffle behavior
-   Seeking
-   Background playback
-   Metadata loading
-   Error recovery

------------------------------------------------------------------------

# 17. Future Enhancements

-   Gapless playback
-   Crossfade
-   ReplayGain
-   Audio normalization
-   Visualizer
-   DSP plugins
-   Streaming plugin architecture

------------------------------------------------------------------------

# 18. Acceptance Criteria

The playback subsystem is successful when:

-   Audio playback is stable on Android and Windows.
-   Queue operations are reliable.
-   Background playback behaves correctly.
-   Metadata updates are reflected immediately.
-   Platform-specific integrations remain isolated.
-   Playback logic remains platform-independent.

------------------------------------------------------------------------

# Revision History

  Version   Date            Description
  --------- --------------- -------------------------------
  1.0.0     Initial Draft   Initial Playback Architecture
