import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/quran_meta.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';
import 'package:islamy/quran/repository/cloud_quran.dart';
import 'package:islamy/quran/store/quran_store.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class QuranManager {
  static late final File artWork;

  const QuranManager._();
  static const String mergedSurahFileName = 'merged.mp3';
  static const String durationJsonFileName = 'durations.json';
  static const List<String> noMediaPlatforms = ['android', 'fuchsia'];
  static Future<void> init() async {
    CloudQuran.init();
    await QuranStore.init();
    await _initDefaultArtImage();
  }

  static Future<void> _initDefaultArtImage() async {
    ByteData bytes = await rootBundle.load('assets/images/logo_with_text.png');
    artWork = File((await getApplicationDocumentsDirectory()).path +
        Platform.pathSeparator +
        'logo.png');
    if (!artWork.existsSync() || artWork.lengthSync() == 0) {
      await artWork.writeAsBytes(bytes.buffer.asUint8List());
    }
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
}
