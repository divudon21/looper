import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:looper_player/features/library/domain/models/models.dart';
import 'package:looper_player/features/youtube_music/services/youtube_player_integration.dart';

part 'youtube_search_provider.g.dart';

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

@Riverpod(keepAlive: true)
class YouTubeSearch extends _$YouTubeSearch {
  final YouTubePlayerIntegration _ytIntegration = YouTubePlayerIntegration();

  @override
  YouTubeSearchState build() => const YouTubeSearchState();

  /// Search YouTube Music
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const YouTubeSearchState();
      return;
    }

    state = state.copyWith(isLoading: true, error: null, query: query);

    try {
      final results = await _ytIntegration.searchAsSongs(query);
      state = YouTubeSearchState(results: results, isLoading: false, query: query);
    } catch (e) {
      state = YouTubeSearchState(
        isLoading: false,
        error: e.toString(),
        results: [],
        query: query,
      );
    }
  }

  /// Clear results
  void clear() {
    state = const YouTubeSearchState();
  }
}
