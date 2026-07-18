# 04-Database-Design-Document.md

# Aash Player Database Design Document (DDD)

**Version:** 1.0.0\
**Status:** Draft

------------------------------------------------------------------------

# Executive Summary

This document defines the logical and physical database design for Aash
Player. The application uses **Drift** as its local persistence layer to
provide an offline-first, performant, and maintainable storage solution
shared across Android and Windows.

------------------------------------------------------------------------

# 1. Design Goals

-   Offline-first architecture
-   Fast query performance
-   Scalable schema
-   Reliable migrations
-   Data integrity
-   Easy backup and restore

------------------------------------------------------------------------

# 2. Database Technology

  Component         Technology
  ----------------- -------------------
  Database Engine   SQLite
  ORM               Drift
  Language          Dart
  Platform          Android & Windows

------------------------------------------------------------------------

# 3. Data Model Overview

Core entities:

-   Songs
-   Albums
-   Artists
-   Genres
-   Playlists
-   Playlist Items
-   Favorites
-   Queue
-   Lyrics
-   Artwork Cache
-   Settings
-   Search History

------------------------------------------------------------------------

# 4. Entity Relationships

``` text
Artist
  │
  ├── Album
  │      │
  │      └── Song
  │
Genre ───────┘

Playlist
   │
   └── PlaylistItem ─── Song

Queue ──────────────── Song
Favorites ──────────── Song
Lyrics ─────────────── Song
```

------------------------------------------------------------------------

# 5. Table Specifications

## Songs

Fields:

-   id (PK)
-   title
-   artistId
-   albumId
-   genreId
-   trackNumber
-   discNumber
-   duration
-   year
-   filePath
-   artworkPath
-   bitrate
-   sampleRate
-   dateAdded
-   lastPlayed
-   playCount
-   isFavorite

------------------------------------------------------------------------

## Artists

-   id
-   name
-   artwork
-   albumCount
-   songCount

------------------------------------------------------------------------

## Albums

-   id
-   artistId
-   title
-   artwork
-   year

------------------------------------------------------------------------

## Genres

-   id
-   name

------------------------------------------------------------------------

## Playlists

-   id
-   name
-   description
-   createdAt
-   modifiedAt

------------------------------------------------------------------------

## PlaylistItems

-   playlistId
-   songId
-   position

------------------------------------------------------------------------

## Queue

-   id
-   songId
-   position

------------------------------------------------------------------------

## Lyrics

-   songId
-   type
-   content
-   language

------------------------------------------------------------------------

## Settings

-   key
-   value

------------------------------------------------------------------------

## SearchHistory

-   id
-   keyword
-   searchedAt

------------------------------------------------------------------------

# 6. Indexing Strategy

Indexes should exist on:

-   Song title
-   Artist name
-   Album title
-   Genre
-   File path
-   Playlist position

------------------------------------------------------------------------

# 7. Data Access Layer

Drift DAOs:

-   SongDao
-   ArtistDao
-   AlbumDao
-   GenreDao
-   PlaylistDao
-   QueueDao
-   SettingsDao
-   SearchDao

Repositories consume DAOs instead of executing SQL directly.

------------------------------------------------------------------------

# 8. Migration Strategy

Each schema change requires:

1.  Version increment
2.  Migration script
3.  Data preservation
4.  Regression testing

No destructive migrations without explicit approval.

------------------------------------------------------------------------

# 9. Backup & Restore

Backups should include:

-   Database
-   Settings
-   Playlists
-   Favorites
-   Queue
-   User preferences

Music files are not copied; only references are stored.

------------------------------------------------------------------------

# 10. Caching Strategy

Cache:

-   Artwork
-   Search results
-   Recently accessed metadata

Cache must be safely disposable.

------------------------------------------------------------------------

# 11. Performance Guidelines

-   Lazy loading
-   Pagination for large libraries
-   Batch writes
-   Indexed lookups
-   Background scanning

------------------------------------------------------------------------

# 12. Data Integrity

Rules:

-   Foreign keys enforced
-   Cascading updates where appropriate
-   Unique constraints on file paths
-   Transactional updates

------------------------------------------------------------------------

# 13. Security

-   Validate imported data
-   Avoid SQL injection through Drift APIs
-   Protect user preferences
-   Never store unnecessary personal data

------------------------------------------------------------------------

# 14. Testing

Required:

-   DAO tests
-   Repository tests
-   Migration tests
-   Backup/Restore tests
-   Large library performance tests

------------------------------------------------------------------------

# 15. Acceptance Criteria

The database design is successful when:

-   Supports offline-first usage
-   Maintains referential integrity
-   Performs efficiently on large libraries
-   Handles schema migrations safely
-   Integrates cleanly with the repository layer

------------------------------------------------------------------------

# Revision History

  Version   Date            Description
  --------- --------------- ----------------------------------
  1.0.0     Initial Draft   Initial Database Design Document
