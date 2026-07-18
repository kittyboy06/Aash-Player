# 04-Database-Design-Document-v3.md

# Aash Player Database Design Document (v3.0)

**Version:** 3.0.0\
**Status:** Living Database Blueprint

------------------------------------------------------------------------

# Executive Summary

This document specifies the complete database architecture for Aash
Player. It defines the logical data model, Drift schema design,
relationships, migrations, indexing strategy, repository mapping,
caching policies, and data integrity rules. It is the authoritative
reference for implementing the persistence layer.

------------------------------------------------------------------------

# 1. Database Objectives

-   Fast local storage
-   Reliable metadata persistence
-   Efficient queries
-   Offline-first operation
-   Safe schema evolution

------------------------------------------------------------------------

# 2. Technology Stack

  Layer      Technology
  ---------- -------------------
  ORM        Drift
  Database   SQLite
  Platform   Android & Windows

------------------------------------------------------------------------

# 3. Design Principles

-   Normalize where practical
-   Immutable primary keys
-   Explicit foreign keys
-   Indexed search fields
-   Repository-only access

------------------------------------------------------------------------

# 4. Entity Relationship Overview

``` text
Artists
   │
Albums
   │
Songs
   │
PlaylistSongs
   │
Playlists

Songs
 ├── Lyrics
 ├── Favorites
 └── History
```

------------------------------------------------------------------------

# 5. Core Tables

## Songs

Fields:

-   id (PK)
-   title
-   albumId
-   artistId
-   filePath
-   duration
-   trackNumber
-   discNumber
-   genre
-   year
-   bitrate
-   sampleRate
-   artworkPath
-   lyrics
-   playCount
-   lastPlayed
-   dateAdded

Indexes:

-   title
-   albumId
-   artistId
-   genre
-   lastPlayed

------------------------------------------------------------------------

## Albums

-   id
-   name
-   artistId
-   artworkPath
-   year

------------------------------------------------------------------------

## Artists

-   id
-   name
-   artworkPath

------------------------------------------------------------------------

## Playlists

-   id
-   name
-   createdAt
-   modifiedAt

------------------------------------------------------------------------

## PlaylistSongs

-   playlistId
-   songId
-   position

Composite primary key:

(playlistId, songId)

------------------------------------------------------------------------

# 6. Relationships

-   Artist → Albums (1:N)
-   Album → Songs (1:N)
-   Playlist → PlaylistSongs (1:N)
-   Song → PlaylistSongs (1:N)

Referential integrity must be enforced.

------------------------------------------------------------------------

# 7. DAO Layer

Each table exposes:

-   Insert
-   Update
-   Delete
-   Query
-   Watch streams

DAOs contain SQL only.

------------------------------------------------------------------------

# 8. Repository Mapping

  Repository           Tables
  -------------------- --------------------------
  LibraryRepository    Songs, Albums, Artists
  PlaylistRepository   Playlists, PlaylistSongs
  MetadataRepository   Songs
  HistoryRepository    Songs

Repositories encapsulate all persistence logic.

------------------------------------------------------------------------

# 9. Migration Strategy

Schema changes require:

1.  Version increment
2.  Migration script
3.  Compatibility tests
4.  Backup verification

Destructive migrations are prohibited unless explicitly approved.

------------------------------------------------------------------------

# 10. Caching Strategy

-   Cache frequently accessed library data
-   Invalidate on rescans or metadata edits
-   Avoid stale playback metadata

------------------------------------------------------------------------

# 11. Data Integrity Rules

-   No orphan playlist entries
-   Unique song identifiers
-   Validate foreign keys
-   Reject invalid metadata
-   Preserve user playlists during upgrades

------------------------------------------------------------------------

# 12. Performance Guidelines

-   Use indexes for search
-   Batch writes where possible
-   Avoid N+1 queries
-   Profile slow queries
-   Stream large result sets

------------------------------------------------------------------------

# 13. Backup & Restore

Persist:

-   Database
-   Playlists
-   Favorites
-   Playback history
-   User settings

Validate backups before restore.

------------------------------------------------------------------------

# 14. Security

-   Validate imported data
-   Restrict file access
-   Prevent SQL injection through parameterized queries
-   Never expose raw database access to UI

------------------------------------------------------------------------

# 15. Testing

Required:

-   DAO tests
-   Repository tests
-   Migration tests
-   Integrity tests
-   Backup/restore tests
-   Performance benchmarks

------------------------------------------------------------------------

# 16. Future Enhancements

-   Full-text search (FTS5)
-   Smart playlists
-   Multiple libraries
-   Cloud synchronization
-   Incremental indexing

------------------------------------------------------------------------

# 17. Acceptance Criteria

The database design is complete when:

-   All entities and relationships are documented.
-   Repository mappings are defined.
-   Migration and backup strategies are established.
-   Performance and integrity requirements are satisfied.

------------------------------------------------------------------------

# Revision History

  -----------------------------------------------------------------------
  Version                Date            Description
  ---------------------- --------------- --------------------------------
  3.0.0                  Initial Draft   Expanded database design into an
                                         implementation blueprint with
                                         entities, relationships,
                                         repositories, migrations,
                                         indexing, caching, security, and
                                         testing.

  -----------------------------------------------------------------------
