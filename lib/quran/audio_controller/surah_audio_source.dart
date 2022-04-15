part of quran;

class SurahAudioSource extends DashAudioSource {
  TheHolyQuran quran;
  Surah surah;

  SurahAudioSource({
    required this.quran,
    required this.surah,
    required Uri uri,
  }) : super(uri);

  static Future<SurahAudioSource> create({
    required TheHolyQuran quran,
    required Surah surah,
  }) async {
    File file = await QuranStore.mergedSurahFile(quran.edition, surah);
    return SurahAudioSource(quran: quran, surah: surah, uri: file.uri);
  }

  factory SurahAudioSource.from(UriAudioSource source) {
    if (source is SurahAudioSource) return source;
    String path = source.uri.toFilePath(windows: Platform.isWindows);
    List<String> words = path.split(Platform.pathSeparator);
    int surahNumber = int.parse(words[words.length - 2]);
    String id = words[words.length - 3];
    TheHolyQuran quran = QuranStore._getQuran(QuranStore._listEditions()
        .singleWhere((element) => element.identifier == id))!;
    return SurahAudioSource(
        quran: quran,
        surah: quran.surahs
            .singleWhere((element) => element.number == surahNumber),
        uri: source.uri);
  }
}
