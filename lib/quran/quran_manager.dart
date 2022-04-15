library quran;

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/quran_meta.dart';
import 'package:islamy/quran/models/sajda.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:duration/duration.dart' as duration_formater;
import 'package:duration/locale.dart';
import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_min/return_code.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:islamy/quran/models/enums_values.dart';
import 'package:islamy/quran/models/juz.dart';
import 'package:islamy/quran/quran_player_controller.dart';
part 'store/quran_store.dart';
part 'repository/cloud_quran.dart';

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

  static Future<List<Edition>> downloadEditions() async {
    List<Edition> editions = QuranStore.listEditions();
    if (editions.isEmpty) {
      editions = await CloudQuran.listEditions();
      await QuranStore.addEditions(editions);
    }
    return editions;
  }

  static Future<TheHolyQuran> downloadQuran({
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

  static Future<QuranMeta> downloadQuranMeta({
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

  static bool isQuranDownloaded(Edition edition) =>
      QuranStore.getQuran(edition) != null;
  static TheHolyQuran getQuran(Edition edition) =>
      QuranStore.getQuran(edition)!;

  static Future<void> downloadSurah({
    required Edition edition,
    required Surah surah,
    Function(int index)? onAyahDownloaded,
  }) =>
      CloudQuran.downloadSurah(
          edition: edition, surah: surah, onAyahDownloaded: onAyahDownloaded);
}
