import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:looper_player/features/library/domain/models/models.dart';
import 'package:looper_player/features/youtube_music/services/youtube_player_integration.dart';

/// State for YouTube search
class YouTubeSearchState {
  final bool isLoading;
  final List<Song> results;
  final String? error;

  const YouTubeSearchState({
    this.isLoading = false,
    this.results = const [],
    this.error,
  });

  YouTubeSearchState copyWith({
    bool? isLoading,
    List<Song>? results,
    String? error,
  }) {
    return YouTubeSearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      error: error,
    );
  }
}

/// Provider for YouTube search functionality
class YouTubeSearchNotifier extends StateNotifier<YouTubeSearchState> {
  final YouTubePlayerIntegration _ytIntegration;

  YouTubeSearchNotifier(this._ytIntegration) : super(const YouTubeSearchState());

  /// Search YouTube Music
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const YouTubeSearchState();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final results = await _ytIntegration.searchAsSongs(query);
      state = YouTubeSearchState(results: results, isLoading: false);
    } catch (e) {
      state = YouTubeSearchState(
        isLoading: false,
        error: e.toString(),
        results: [],
      );
    }
  }

  /// Clear results
  void clear() {
    state = const YouTubeSearchState();
  }
}

/// Provider for YouTube search state
final youtubeSearchProvider =
    StateNotifierProvider<YouTubeSearchNotifier, YouTubeSearchState>((ref) {
  return YouTubeSearchNotifier(YouTubePlayerIntegration());
});
