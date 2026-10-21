import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// YouTube Music streaming service with robust error handling
/// Inspired by Namida's approach for reliability
class YouTubeMusicService {
  static final YouTubeMusicService _instance = YouTubeMusicService._internal();
  factory YouTubeMusicService() => _instance;
  YouTubeMusicService._internal();

  late final YoutubeExplode _yt;
  
  // Cache for stream URLs (they expire after ~6 hours)
  final Map<String, _CachedStream> _streamCache = {};
  final Duration _cacheExpiry = const Duration(hours: 5); // Refresh before expiry
  
  // Multiple YouTube API clients to try (fallback strategy)
  // Based on youtube_explode_dart best practices
  final List<YoutubeApiClient> _clients = [
    YoutubeApiClient.ios,
    YoutubeApiClient.android,
    YoutubeApiClient.web,
  ];

  /// Initialize the service
  Future<void> initialize() async {
    _yt = YoutubeExplode();
    debugPrint('[YouTubeMusicService] Initialized');
  }

  /// Search for tracks on YouTube Music
  /// Returns list of video results with metadata
  Future<List<YouTubeTrack>> search(String query, {int maxResults = 20}) async {
    try {
      final searchList = await _yt.search.search(query);
      
      return searchList
          .whereType<Video>()
          .take(maxResults)
          .map((video) => YouTubeTrack.fromVideo(video))
          .toList();
    } catch (e, stack) {
      debugPrint('[YouTubeMusicService] Search error: $e');
      debugPrint('[YouTubeMusicService] Stack: $stack');
      throw YouTubeMusicException('Search failed: ${e.toString()}');
    }
  }

  /// Get audio stream URL for a video
  /// Implements Namida's strategy:
  /// 1. Check cache first
  /// 2. Try multiple clients if one fails
  /// 3. Cache the result
  /// 4. Handle URL expiry
  Future<String> getAudioStreamUrl(String videoId) async {
    // Check cache first
    final cached = _streamCache[videoId];
    if (cached != null && !cached.isExpired) {
      debugPrint('[YouTubeMusicService] Using cached stream for $videoId');
      return cached.url;
    }

    // Try each client until one works
    for (final client in _clients) {
      try {
        debugPrint('[YouTubeMusicService] Trying client: ${client.name}');
        
        final manifest = await _yt.videos.streamsClient.getManifest(
          videoId,
          ytClients: [client],
        );
        
        // Get highest quality audio-only stream
        final audioStream = manifest.audioOnly.withHighestBitrate();
        final url = audioStream.url.toString();
        
        // Validate URL works (HEAD request)
        if (await _validateStreamUrl(url)) {
          // Cache the URL
          _streamCache[videoId] = _CachedStream(
            url: url,
            expiresAt: DateTime.now().add(_cacheExpiry),
          );
          
          debugPrint('[YouTubeMusicService] Got stream URL (bitrate: ${audioStream.bitrate})');
          return url;
        }
      } catch (e) {
        debugPrint('[YouTubeMusicService] Client ${client.name} failed: $e');
        continue; // Try next client
      }
    }

    // All clients failed
    throw YouTubeMusicException('Failed to get stream URL from all clients');
  }

  /// Get video metadata without stream URL
  Future<YouTubeTrack?> getVideoInfo(String videoId) async {
    try {
      final video = await _yt.videos.get(videoId);
      return YouTubeTrack.fromVideo(video);
    } catch (e) {
      debugPrint('[YouTubeMusicService] getVideoInfo error: $e');
      return null;
    }
  }

  /// Validate if stream URL is accessible
  Future<bool> _validateStreamUrl(String url) async {
    try {
      final client = HttpClient();
      final request = await client.headUrl(Uri.parse(url));
      final response = await request.close();
      await response.drain();
      
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      debugPrint('[YouTubeMusicService] URL validation failed: $e');
      return false;
    }
  }

  /// Clear stream cache
  void clearCache() {
    _streamCache.clear();
    debugPrint('[YouTubeMusicService] Cache cleared');
  }

  /// Dispose resources
  void dispose() {
    _yt.close();
    _streamCache.clear();
    debugPrint('[YouTubeMusicService] Disposed');
  }
}

/// Cached stream URL with expiry
class _CachedStream {
  final String url;
  final DateTime expiresAt;

  _CachedStream({
    required this.url,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

/// YouTube track data model
class YouTubeTrack {
  final String videoId;
  final String title;
  final String author;
  final Duration duration;
  final String? thumbnailUrl;
  final String? description;

  YouTubeTrack({
    required this.videoId,
    required this.title,
    required this.author,
    required this.duration,
    this.thumbnailUrl,
    this.description,
  });

  factory YouTubeTrack.fromVideo(Video video) {
    return YouTubeTrack(
      videoId: video.id.value,
      title: video.title,
      author: video.author,
      duration: video.duration ?? Duration.zero,
      thumbnailUrl: video.thumbnails.highResUrl,
      description: video.description,
    );
  }

  @override
  String toString() => 'YouTubeTrack($videoId: $title by $author)';
}

/// Custom exception for YouTube Music errors
class YouTubeMusicException implements Exception {
  final String message;
  YouTubeMusicException(this.message);

  @override
  String toString() => 'YouTubeMusicException: $message';
}
