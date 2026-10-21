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

/// Provider for YouTube search functionality using ChangeNotifier
class YouTubeSearchNotifier extends ChangeNotifier {
  final YouTubePlayerIntegration _ytIntegration;
  YouTubeSearchState _state = const YouTubeSearchState();

  YouTubeSearchState get state => _state;

  YouTubeSearchNotifier(this._ytIntegration);

  /// Search YouTube Music
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _state = const YouTubeSearchState();
      notifyListeners();
      return;
    }

    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final results = await _ytIntegration.searchAsSongs(query);
      _state = YouTubeSearchState(results: results, isLoading: false);
      notifyListeners();
    } catch (e) {
      _state = YouTubeSearchState(
        isLoading: false,
        error: e.toString(),
        results: [],
      );
      notifyListeners();
    }
  }

  /// Clear results
  void clear() {
    _state = const YouTubeSearchState();
    notifyListeners();
  }
}

/// Provider for YouTube search state
final youtubeSearchProvider =
    ChangeNotifierProvider<YouTubeSearchNotifier>((ref) {
  return YouTubeSearchNotifier(YouTubePlayerIntegration());
});

/// Helper extension to get notifier from provider
extension YouTubeSearchProviderX on YouTubeSearchNotifier {
  YouTubeSearchNotifier get notifier => this;
}
