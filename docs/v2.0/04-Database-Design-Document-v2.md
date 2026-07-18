# 04-Database-Design-Document-v2.md

# Aash Player Database Design Document (v2.0)

**Version:** 2.0.0\
**Status:** Living Document

------------------------------------------------------------------------

# Executive Summary

This document defines the logical and physical database design for Aash
Player. It expands the v1.0 database documentation by describing
entities, relationships, indexing strategy, migrations, repository
mappings, backup procedures, and performance considerations for the
Drift-powered SQLite database.

------------------------------------------------------------------------

# 1. Objectives

-   Reliable local storage
-   High-performance queries
-   Offline-first operation
-   Data integrity
-   Easy schema evolution

------------------------------------------------------------------------

# 2. Database Technology

-   SQLite
-   Drift ORM
-   Local-first persistence
-   Migration support
-   Transaction support

------------------------------------------------------------------------

# 3. Design Principles

-   Normalize where practical
-   Avoid duplicated data
-   Use foreign keys
-   Keep migrations reversible
-   Optimize read-heavy workloads

------------------------------------------------------------------------

# 4. Entity Relationship Overview

``` text
Artists
   │
Albums
   │
Songs
   │
PlaylistItems ─── Playlists

Songs ─── Lyrics
Songs ─── Genres
Settings
SearchHistory
Queue
```

------------------------------------------------------------------------

# 5. Core Tables

## Songs

Purpose: - Store indexed audio files and metadata.

Typical fields: - id - path - title - artistId - albumId - genreId -
duration - trackNumber - artworkPath - lyricsId - dateAdded -
lastModified

Indexes: - path (unique) - title - artistId - albumId

------------------------------------------------------------------------

## Albums

Stores album information.

Fields: - id - title - artistId - artworkPath

------------------------------------------------------------------------

## Artists

Stores artist information.

Fields: - id - name - artworkPath

------------------------------------------------------------------------

## Genres

Stores music genres.

------------------------------------------------------------------------

## Playlists

Stores user-created playlists.

------------------------------------------------------------------------

## PlaylistItems

Maintains playlist ordering.

Fields: - playlistId - songId - position

------------------------------------------------------------------------

## Queue

Stores current playback queue.

------------------------------------------------------------------------

## Lyrics

Stores embedded or user-edited lyrics.

------------------------------------------------------------------------

## Settings

Stores application preferences.

------------------------------------------------------------------------

## SearchHistory

Stores recent search terms.

------------------------------------------------------------------------

# 6. Relationships

-   Artist → Albums (1:N)
-   Album → Songs (1:N)
-   Genre → Songs (1:N)
-   Playlist → PlaylistItems (1:N)
-   Song → Lyrics (1:1)

Enforce foreign key constraints where applicable.

------------------------------------------------------------------------

# 7. DAO Layer

Each entity exposes a dedicated DAO responsible for:

-   CRUD operations
-   Optimized queries
-   Transactions
-   Stream updates

Repositories consume DAOs instead of raw SQL.

------------------------------------------------------------------------

# 8. Repository Mapping

  Repository           Primary Tables
  -------------------- --------------------------
  LibraryRepository    Songs, Albums, Artists
  PlaybackRepository   Queue, Songs
  PlaylistRepository   Playlists, PlaylistItems
  SettingsRepository   Settings
  SearchRepository     SearchHistory

------------------------------------------------------------------------

# 9. Migration Strategy

Every schema change must include:

-   Version number
-   Forward migration
-   Data preservation
-   Migration tests
-   Rollback considerations (when practical)

------------------------------------------------------------------------

# 10. Backup & Restore

Backup includes:

-   Database
-   Playlists
-   Queue
-   Settings
-   Lyrics

Restore must validate schema compatibility before import.

------------------------------------------------------------------------

# 11. Performance Strategy

-   Index frequently queried columns
-   Batch write operations
-   Lazy-load large datasets
-   Paginate long lists
-   Profile expensive queries

------------------------------------------------------------------------

# 12. Data Integrity

-   Foreign key enforcement
-   Unique constraints
-   Transactions for multi-table updates
-   Validation before persistence

------------------------------------------------------------------------

# 13. Security

-   Local-only storage by default
-   Validate imported backup files
-   Avoid storing unnecessary sensitive information

------------------------------------------------------------------------

# 14. Testing

Required tests:

-   CRUD operations
-   Migrations
-   Constraint validation
-   DAO queries
-   Repository mappings
-   Backup & restore

------------------------------------------------------------------------

# 15. Future Enhancements

-   Full-text search
-   Smart playlist indexes
-   Query profiling
-   Optional encrypted database
-   Metadata caching improvements

------------------------------------------------------------------------

# 16. Acceptance Criteria

Database design is complete when:

-   Schema supports all product features.
-   Migrations preserve user data.
-   Queries remain performant on large libraries.
-   Repository contracts remain stable.
-   Backup and restore operate reliably.

------------------------------------------------------------------------

# Revision History

  -----------------------------------------------------------------------
  Version                Date            Description
  ---------------------- --------------- --------------------------------
  2.0.0                  Initial Draft   Expanded database design with
                                         entities, relationships, DAO
                                         layer, migrations, performance
                                         strategy, and repository
                                         mapping.

  -----------------------------------------------------------------------
