import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:looper_player/features/library/domain/models/models.dart';
import 'package:looper_player/features/youtube_music/services/youtube_player_integration.dart';

/// State for YouTube search
class YouTubeSearchState {
  final bool isLoading;
  final List<Song> results;
  final String? error;
  final String query;

  const YouTubeSearchState({
    this.isLoading = false,
    this.results = const [],
    this.error,
    this.query = '',
  });

  YouTubeSearchState copyWith({
    bool? isLoading,
    List<Song>? results,
    String? error,
    String? query,
  }) {
    return YouTubeSearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      error: error,
      query: query ?? this.query,
    );
  }
}

/// Provider for YouTube search state
final youtubeSearchProvider = StateProvider<YouTubeSearchState>((ref) {
  return const YouTubeSearchState();
});

/// Provider for YouTube search functionality
final youtubeSearchService = Provider<YouTubePlayerIntegration>((ref) {
  return YouTubePlayerIntegration();
});

/// Search YouTube Music - standalone function
Future<void> searchYouTube(WidgetRef ref, String query) async {
  final service = ref.read(youtubeSearchService);
  final stateProvider = ref.read(youtubeSearchProvider.notifier);
  
  if (query.trim().isEmpty) {
    stateProvider.state = const YouTubeSearchState();
    return;
  }

  stateProvider.state = stateProvider.state.copyWith(isLoading: true, error: null, query: query);

  try {
    final results = await service.searchAsSongs(query);
    stateProvider.state = YouTubeSearchState(results: results, isLoading: false, query: query);
  } catch (e) {
    stateProvider.state = YouTubeSearchState(
      isLoading: false,
      error: e.toString(),
      results: [],
      query: query,
    );
  }
}
