// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(YouTubeSearch)
final youTubeSearchProvider = YouTubeSearchProvider._();

final class YouTubeSearchProvider
    extends $NotifierProvider<YouTubeSearch, YouTubeSearchState> {
  YouTubeSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'youTubeSearchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$youTubeSearchHash();

  @$internal
  @override
  YouTubeSearch create() => YouTubeSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(YouTubeSearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<YouTubeSearchState>(value),
    );
  }
}

String _$youTubeSearchHash() => r'5e61a3bcb924d336f1a68801627abb47ffdd28a3';

abstract class _$YouTubeSearch extends $Notifier<YouTubeSearchState> {
  YouTubeSearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<YouTubeSearchState, YouTubeSearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<YouTubeSearchState, YouTubeSearchState>,
              YouTubeSearchState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
