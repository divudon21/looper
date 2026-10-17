part of 'theme_settings_tiles.dart';

class FontStyleSelectionTile extends ConsumerWidget {
  const FontStyleSelectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final currentFont = settings.customFontFamily;
    
    // 5 preset font styles with good visual differences
    final fontStyles = [
      {'name': 'Default', 'font': AppFonts.stackSansText, 'desc': 'Clean & Modern'},
      {'name': 'Elegant', 'font': AppFonts.jost, 'desc': 'Geometric & Refined'},
      {'name': 'Bold', 'font': AppFonts.poppins, 'desc': 'Strong & Rounded'},
      {'name': 'Technical', 'font': AppFonts.spaceGrotesk, 'desc': 'Modern & Precise'},
      {'name': 'Friendly', 'font': 'Plus Jakarta Sans', 'desc': 'Warm & Approachable'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(LucideIcons.type, color: Colors.white70),
          title: Text('Font Style', style: _tileTitleStyle()),
          subtitle: Text(
            'Choose a preset font style',
            style: _tileSubtitleStyle(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: fontStyles.map((style) {
              final isSelected = currentFont == style['font'];
              final accentColor = Color(settings.accentColor);
              
              return GestureDetector(
                onTap: () {
                  AppHaptics.light();
                  ref.read(settingsProvider.notifier).updateCustomFontFamily(style['font'] as String);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accentColor.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? accentColor
                          : Colors.white.withValues(alpha: 0.08),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            style['name'] as String,
                            style: AppFonts.familyStyle(
                              style['font'] as String,
                              color: isSelected ? accentColor : Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            Icon(
                              LucideIcons.check,
                              color: accentColor,
                              size: 20,
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The quick brown fox jumps over the lazy dog',
                        style: AppFonts.familyStyle(
                          style['font'] as String,
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        style['desc'] as String,
                        style: AppFonts.jostStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class UseNewFontTile extends ConsumerWidget {
  const UseNewFontTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;
    return SwitchListTile(
      secondary: const Icon(LucideIcons.type, color: Colors.white70),
      title: Text(l10n.useCustomFont, style: _tileTitleStyle()),
      subtitle: Text(l10n.useCustomFontDesc, style: _tileSubtitleStyle()),
      activeThumbColor: Color(settings.accentColor),
      value: settings.useNewFont,
      onChanged: (value) {
        ref.read(settingsProvider.notifier).updateUseNewFont(value);
      },
    );
  }
}

class FontFamilySelectionTile extends ConsumerWidget {
  const FontFamilySelectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;
    return _FontFamilyTile(
      title: l10n.selectFontFamily,
      subtitle: l10n.activeFont(settings.customFontFamily),
      family: settings.customFontFamily,
      onChanged: (value) =>
          ref.read(settingsProvider.notifier).updateCustomFontFamily(value),
    );
  }
}

class FontWeightSelectionTile extends ConsumerWidget {
  const FontWeightSelectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;
    return _FontWeightTile(
      title: l10n.fontWeightAdjustment,
      weights: const [100, 200, 300, 400, 500, 600, 700, 800, 900],
      baseWeight: 400,
      delta: settings.customFontWeightDelta,
      accentColor: Color(settings.accentColor),
      onDelta: (value) => ref
          .read(settingsProvider.notifier)
          .updateCustomFontWeightDelta(value),
    );
  }
}

class UseNewFontLyricsTile extends ConsumerWidget {
  const UseNewFontLyricsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;
    return SwitchListTile(
      secondary: const Icon(LucideIcons.type, color: Colors.white70),
      title: Text(l10n.useCustomFontLyrics, style: _tileTitleStyle()),
      subtitle: Text(l10n.useCustomFontLyricsDesc, style: _tileSubtitleStyle()),
      activeThumbColor: Color(settings.accentColor),
      value: settings.useNewFontLyrics,
      onChanged: (value) {
        ref.read(settingsProvider.notifier).updateUseNewFontLyrics(value);
      },
    );
  }
}

class LyricsFontFamilySelectionTile extends ConsumerWidget {
  const LyricsFontFamilySelectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;
    return _FontFamilyTile(
      title: l10n.lyricsFontFamily,
      subtitle: l10n.activeLyricsFont(
        settings.customFontFamilyLyrics ?? AppFonts.stackSansText,
      ),
      family: settings.customFontFamilyLyrics,
      onChanged: (value) => ref
          .read(settingsProvider.notifier)
          .updateCustomFontFamilyLyrics(value),
    );
  }
}

class LyricsFontWeightSelectionTile extends ConsumerWidget {
  const LyricsFontWeightSelectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;
    return _FontWeightTile(
      title: l10n.lyricsFontWeight,
      weights: const [400, 500, 600, 700, 800, 900],
      baseWeight: 700,
      delta: settings.activeLyricsFontWeightDelta,
      accentColor: Color(settings.accentColor),
      onDelta: (value) => ref
          .read(settingsProvider.notifier)
          .updateActiveLyricsFontWeightDelta(value),
    );
  }
}

/// A font-family picker row: a dropdown of [AppFonts.selectableFamilies]
/// showing [family], or Stack Sans Text when that is not one of them.
class _FontFamilyTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? family;
  final ValueChanged<String> onChanged;

  const _FontFamilyTile({
    required this.title,
    required this.subtitle,
    required this.family,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const availableFonts = AppFonts.selectableFamilies;
    return ListTile(
      leading: const Icon(LucideIcons.type, color: Colors.white70),
      title: Text(title, style: _tileTitleStyle()),
      subtitle: Text(subtitle, style: _tileSubtitleStyle()),
      trailing: DropdownButton<String>(
        value: availableFonts.contains(family)
            ? family
            : AppFonts.stackSansText,
        dropdownColor: const Color(0xFF1A1A1A),
        underline: const SizedBox(),
        items: availableFonts.map((font) {
          return DropdownMenuItem<String>(
            value: font,
            child: Text(font, style: AppFonts.jostStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}

/// A font-weight picker: a row of [weights] chips, each drawn in its own
/// weight. The stored value is a [delta] in steps of 100 from [baseWeight].
class _FontWeightTile extends StatelessWidget {
  final String title;
  final List<int> weights;
  final int baseWeight;
  final int delta;
  final Color accentColor;
  final ValueChanged<int> onDelta;

  const _FontWeightTile({
    required this.title,
    required this.weights,
    required this.baseWeight,
    required this.delta,
    required this.accentColor,
    required this.onDelta,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedWeight = baseWeight + (delta * 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(LucideIcons.bold, color: Colors.white70),
          title: Text(title, style: _tileTitleStyle()),
          subtitle: Text(
            '${l10n.currentWeight}: $selectedWeight',
            style: _tileSubtitleStyle(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: weights.length,
              itemBuilder: (context, index) {
                final w = weights[index];
                final isSelected = w == selectedWeight;
                return GestureDetector(
                  onTap: () {
                    AppHaptics.light();
                    onDelta((w - baseWeight) ~/ 100);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accentColor
                          : Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.white.withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '$w',
                      style: AppFonts.jostStyle(
                        color: isSelected
                            ? (ThemeData.estimateBrightnessForColor(
                                        accentColor,
                                      ) ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                            : Colors.white70,
                        // w100 is FontWeight.values[0].
                        fontWeight: FontWeight.values[(w ~/ 100) - 1],
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
