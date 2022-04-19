part of quran;

class SurahAudioSource extends DashAudioSource {
  SurahAudioSource({
    required this.quran,
    required this.surah,
    required Uri uri,
  }) : super(uri);

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
    return SurahAudioSource(
      quran: quran,
      surah: quran.surahs
          .singleWhere((Surah element) => element.number == surahNumber),
      uri: source.uri,
    );
  }

  TheHolyQuran quran;
  Surah surah;

  static Future<SurahAudioSource> create({
    required TheHolyQuran quran,
    required Surah surah,
  }) async {
    final File file = await QuranStore.mergedSurahFile(quran.edition, surah);
    return SurahAudioSource(quran: quran, surah: surah, uri: file.uri);
  }
}
