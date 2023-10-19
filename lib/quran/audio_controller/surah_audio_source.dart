part of quran;

/// Curated [DashAudioSource] that passes the surah merged file as [Uri]
/// and restores the [TheHolyQuran] and [Surah] property from the
/// [uri] property.
class SurahAudioSource extends ProgressiveAudioSource {
  SurahAudioSource._({
    required this.quran,
    required this.surah,
    required Uri uri,
  }) : super(uri);

  /// Creates the [SurahAudioSource] from normal [UriAudioSource] or
  /// just cast it if it fits.
  factory SurahAudioSource.from(UriAudioSource source) {
    if (source is SurahAudioSource) return source;
    final String path = source.uri.toFilePath(windows: Platform.isWindows);
    final List<String> words = path.split(Platform.pathSeparator);
    final int surahNumber = int.parse(words[words.length - 2]);
    final String id = words[words.length - 3];
    final TheHolyQuran quran = QuranStore._getQuran(
      QuranStore._listEditions()
          .singleWhere((Edition element) => element.identifier == id),
    )!;
    return SurahAudioSource._(
      quran: quran,
      surah: quran.surahs
          .singleWhere((Surah element) => element.number == surahNumber),
      uri: source.uri,
    );
  }

  TheHolyQuran quran;
  Surah surah;

  /// Method to create a valid instance of [SurahAudioSource]
  static Future<SurahAudioSource> create({
    required TheHolyQuran quran,
    required Surah surah,
  }) async {
    final File file = await QuranStore.mergedSurahFile(quran.edition, surah);
    return SurahAudioSource._(quran: quran, surah: surah, uri: file.uri);
  }
}
