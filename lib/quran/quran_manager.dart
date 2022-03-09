import 'dart:io';

import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/text_quran.dart';
import 'package:islamy/quran/repository/cloud_quran.dart';
import 'package:islamy/quran/store/quran_store.dart';
import 'package:just_audio/just_audio.dart';

class QuranManager {
  const QuranManager._();

  static Future<void> init() async {
    CloudQuran.init();
    await QuranStore.init();
  }

  static Future<List<Edition>> listEditions() async {
    List<Edition> editions = QuranStore.listEditions();
    if (editions.isEmpty) {
      editions = await CloudQuran.listEditions();
      await QuranStore.addEditions(editions);
    }
    return editions;
  }

  static Future<TheHolyQuran> getQuran({Edition? edition}) async {
    edition ??= QuranStore.settings.defaultTextEdition;
    TheHolyQuran? quran = QuranStore.getQuran(edition);
    if (quran == null) {
      quran = await CloudQuran.getQuran(edition: edition);
      QuranStore.addQuran(edition, quran);
    }
    return quran;
  }

  static Future<void> playSurah(TheHolyQuran quran, Surah surah) async {
    AudioPlayer player = AudioPlayer();
    Directory surahDirectory =
        await QuranStore.getDirectoryForSurah(quran, surah);
    await player.setShuffleModeEnabled(false);
    List<FileSystemEntity> ayahs = surahDirectory.listSync();
    ayahs.sort(
      (a1, a2) {
        return a1.path.compareTo(a2.path);
      },
    );
    await player.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: [
          for (var ayahFile in ayahs) AudioSource.uri(ayahFile.uri),
        ],
      ),
      preload: true,
    );
    final complete = player.play();
    player.currentIndexStream.listen((event) {});
    await complete;
    player.dispose();
  }
}
