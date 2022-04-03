import 'dart:io';

import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/quran_meta.dart';
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

  static Future<TheHolyQuran> getQuran({
    required Edition edition,
    void Function(int, int)? onReceiveProgress,
  }) async {
    TheHolyQuran? quran = QuranStore.getQuran(edition);
    if (quran == null) {
      quran = await CloudQuran.getQuran(
          edition: edition, onReceiveProgress: onReceiveProgress);
      QuranStore.addQuran(edition, quran);
    }
    return quran;
  }

  static Future<QuranMeta> getQuranMeta({
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return QuranStore.settings.meta;
    } catch (e) {
      QuranMeta meta =
          await CloudQuran.getQuranMeta(onReceiveProgress: onReceiveProgress);
      QuranStore.settings.meta = meta;
      return meta;
    }
  }

  static Future<void> playSurah(Edition edition, Surah surah) async {
    AudioPlayer player = AudioPlayer();
    Directory surahDirectory =
        await QuranStore.getDirectoryForSurah(edition, surah);
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
