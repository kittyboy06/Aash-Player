# 05-Playback-Architecture-v2.md

# Aash Player Playback Architecture (v2.0)

**Version:** 2.0.0\
**Status:** Living Document

------------------------------------------------------------------------

# Executive Summary

This document defines the playback subsystem architecture for Aash
Player. It expands the v1.0 specification with a complete playback
pipeline, state machine, queue management, audio lifecycle, metadata
synchronization, platform integrations, and future DSP extensibility.

------------------------------------------------------------------------

# 1. Objectives

-   Reliable playback
-   Low-latency audio control
-   Cross-platform consistency
-   Efficient queue management
-   Extensible playback engine

------------------------------------------------------------------------

# 2. Playback Stack

Core technologies:

-   Flutter
-   media_kit
-   libmpv backend
-   Riverpod
-   audiotags
-   Drift

------------------------------------------------------------------------

# 3. Playback Pipeline

``` text
User Action
    │
Playback Controller
    │
PlaySongUseCase
    │
Playback Repository
    │
media_kit Player
    │
libmpv
    │
Operating System Audio Stack
    │
Audio Device
```

Responsibilities:

-   Decode audio
-   Control playback
-   Manage buffering
-   Synchronize state
-   Report playback events

------------------------------------------------------------------------

# 4. Playback State Machine

``` text
Idle
 │
 ▼
Loading
 │
 ▼
Ready
 │
 ▼
Playing
 ├────────────┐
 ▼            │
Paused        │
 │            │
 └──────► Playing
 │
 ▼
Completed
 │
 ▼
Stopped
```

Error transitions may occur from any state and should surface as
recoverable domain failures where possible.

------------------------------------------------------------------------

# 5. Queue Management

Supported operations:

-   Add song
-   Remove song
-   Reorder queue
-   Clear queue
-   Play next
-   Insert next
-   Shuffle queue
-   Repeat queue
-   Save queue state

Queue should persist across app restarts when enabled.

------------------------------------------------------------------------

# 6. Shuffle & Repeat

Shuffle modes:

-   Off
-   Random queue order
-   Deterministic seeded shuffle (future)

Repeat modes:

-   None
-   Repeat One
-   Repeat All

Behavior must remain deterministic and predictable.

------------------------------------------------------------------------

# 7. Metadata Synchronization

Metadata displayed during playback includes:

-   Title
-   Artist
-   Album
-   Artwork
-   Duration
-   Position
-   Lyrics (when available)

Changes made through the metadata editor should be reflected after
refresh or rescan.

------------------------------------------------------------------------

# 8. Platform Integration

## Android

-   Audio Focus
-   Foreground Service
-   Media Session
-   Notification controls
-   Lock screen controls
-   Bluetooth media buttons

## Windows

-   System Media Transport Controls (SMTC)
-   Native keyboard media keys
-   Taskbar integration (future)

------------------------------------------------------------------------

# 9. Playback Lifecycle

Typical flow:

1.  Initialize player
2.  Load media source
3.  Buffer content
4.  Start playback
5.  Update playback position
6.  Handle user controls
7.  Release resources on exit

The player should gracefully recover from interruptions where possible.

------------------------------------------------------------------------

# 10. Error Handling

Possible failures:

-   Missing file
-   Unsupported format
-   Decoder failure
-   Device unavailable
-   Permission issues

Requirements:

-   Friendly user messages
-   Structured logging
-   Automatic recovery when practical

------------------------------------------------------------------------

# 11. Performance Guidelines

-   Lazy-load playlists
-   Avoid redundant metadata parsing
-   Reuse player instance
-   Minimize UI rebuilds
-   Cache artwork where appropriate

------------------------------------------------------------------------

# 12. Testing

Required coverage:

-   Playback controls
-   Queue operations
-   Shuffle logic
-   Repeat modes
-   Seeking
-   Background playback
-   Metadata synchronization
-   Platform integrations

------------------------------------------------------------------------

# 13. Future Enhancements

Potential roadmap:

-   Gapless playback
-   Crossfade
-   ReplayGain
-   Audio normalization
-   DSP plugin architecture
-   Visualizer
-   Equalizer presets
-   Multi-device playback

------------------------------------------------------------------------

# 14. Acceptance Criteria

Playback architecture is complete when:

-   Playback is stable across Android and Windows.
-   Queue behavior is deterministic.
-   Playback state remains synchronized with the UI.
-   Platform media controls operate correctly.
-   Architecture remains extensible for future audio features.

------------------------------------------------------------------------

# Revision History

  -----------------------------------------------------------------------
  Version                Date            Description
  ---------------------- --------------- --------------------------------
  2.0.0                  Initial Draft   Expanded playback architecture
                                         with playback pipeline,
                                         lifecycle, queue management,
                                         platform integration, and future
                                         DSP roadmap.

  -----------------------------------------------------------------------
