import 'package:flutter/foundation.dart';
import 'package:looper_player/features/library/domain/models/models.dart';
import 'package:looper_player/features/youtube_music/services/youtube_music_service.dart';

/// Converts YouTube tracks to Looper's Song model for playback
class YouTubePlayerIntegration {
  static final YouTubePlayerIntegration _instance = YouTubePlayerIntegration._internal();
  factory YouTubePlayerIntegration() => _instance;
  YouTubePlayerIntegration._internal();

  final YouTubeMusicService _ytService = YouTubeMusicService();

  /// Initialize the service
  Future<void> initialize() async {
    await _ytService.initialize();
    debugPrint('[YouTubePlayerIntegration] Initialized');
  }

  /// Convert YouTube track to Song model
  /// Uses a special path format: youtube://<videoId>
  Song youtubeTrackToSong(YouTubeTrack track) {
    return Song()
      ..id = _hashCode(track.videoId)
      ..path = 'youtube://${track.videoId}'
      ..title = track.title
      ..artist = track.author
      ..album = 'YouTube Music'
      ..duration = track.duration.inMilliseconds
      ..artPath = track.thumbnailUrl
      ..dateAdded = DateTime.now()
      ..isFavorite = false;
  }

  /// Get playable URL for a YouTube song
  /// Resolves youtube:// path to actual stream URL
  Future<String> resolveYouTubeUrl(String youtubePath) async {
    if (!youtubePath.startsWith('youtube://')) {
      throw ArgumentError('Not a YouTube path: $youtubePath');
    }

    final videoId = youtubePath.replaceFirst('youtube://', '');
    debugPrint('[YouTubePlayerIntegration] Resolving URL for video: $videoId');
    
    try {
      final url = await _ytService.getAudioStreamUrl(videoId);
      debugPrint('[YouTubePlayerIntegration] Got stream URL: ${url.substring(0, 50)}...');
      return url;
    } catch (e) {
      debugPrint('[YouTubePlayerIntegration] Failed to resolve URL: $e');
      rethrow;
    }
  }

  /// Check if a song path is a YouTube track
  bool isYouTubeSong(String path) {
    return path.startsWith('youtube://');
  }

  /// Search YouTube and return Song objects
  Future<List<Song>> searchAsSongs(String query) async {
    final tracks = await _ytService.search(query);
    return tracks.map(youtubeTrackToSong).toList();
  }

  /// Simple hash function for videoId to generate unique ID
  int _hashCode(String videoId) {
    return videoId.hashCode.abs();
  }

  void dispose() {
    _ytService.dispose();
  }
}
