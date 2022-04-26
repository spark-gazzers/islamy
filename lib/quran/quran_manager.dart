library quran;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:duration/duration.dart' as duration_formater;
import 'package:duration/locale.dart';
import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_min/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:islamy/quran/models/juz.dart';
import 'package:islamy/quran/models/quran_meta.dart';
import 'package:islamy/quran/models/sajda.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

part './audio_controller/quran_player_controller.dart';
part 'audio_controller/surah_audio_source.dart';
part 'audio_controller/surah_media_item.dart';
part 'repository/cloud_quran.dart';
part 'store/quran_store.dart';
part 'tajweed/rules.dart';
part 'tajweed/splitter.dart';

/// Static base manager for all quires/ops on [TheHolyQuran] and it's associates.
class QuranManager {
  const QuranManager._();

  static const List<String> _unsupportedTextEditions = <String>[
    'quran-wordbyword',
    'quran-kids',
    'quran-corpus-qd',
    'quran-wordbyword-2',
    'quran-unicode',
    'quran-uthmani-quran-academy'
  ];

  /// This file is a copy from the app logo copied to the
  /// [getApplicationDocumentsDirectory] as stored file to pass into the native
  /// audio services.
  static late final File artWork;

  /// The generated merged surah file name.
  ///
  ///
  /// Note this file is not available in the [alquran cloud api](https://alquran.cloud)
  /// but merged after fetching individual ayahs files.
  static const String mergedSurahFileName = 'merged.mp3';

  /// The generated duration file which later will be proccessed to be
  /// the [QuranPlayerContoller] identifier for the ayahs positions.
  static const String durationJsonFileName = 'durations.json';

  /// List containing all the no media platforms so the ayahs files
  /// won't show at other media player apps
  static const List<String> noMediaPlatforms = <String>['android', 'fuchsia'];

  /// Unified initializer for all of the quran library initializers.
  static Future<void> init() async {
    await _initDefaultArtImage();
    CloudQuran.init();
    await QuranStore.init();
    await QuranPlayerContoller.init();

    // Start download the necessary models to start

    // Download the editions
    if (QuranStore._listEditions().isEmpty) {
      await QuranManager.downloadEditions();
      // Download quran meta too
      await QuranManager.downloadQuranMeta();
    }
    // Download the default text quran
    if (!QuranManager.isQuranDownloaded(
      QuranStore.settings.defaultTextEdition,
    )) {
      await QuranManager.downloadQuran(
        edition: QuranStore.settings.defaultTextEdition,
      );
    }
    // Download the default audio quran
    if (!QuranManager.isQuranDownloaded(
      QuranStore.settings.defaultAudioEdition,
    )) {
      await QuranManager.downloadQuran(
        edition: QuranStore.settings.defaultAudioEdition,
      );
    }
  }

  static Future<void> _initDefaultArtImage() async {
    final ByteData bytes =
        await rootBundle.load('assets/images/logo_with_text.png');
    artWork = File(
      '${(await getApplicationDocumentsDirectory()).path}'
      '${Platform.pathSeparator}logo.png',
    );
    if (!artWork.existsSync() || artWork.lengthSync() == 0) {
      await artWork.writeAsBytes(bytes.buffer.asUint8List());
    }
  }

  /// Get the store [TheHolyQuran] from the local DB using the
  /// [Edition] id provided.
  static TheHolyQuran getQuranByID(String id) => getQuran(
        QuranStore._listEditions()
            .singleWhere((Edition element) => element.identifier == id),
      );

  /// Download all editions provided from [alquran cloud](https://alquran.cloud/)
  /// and store it in the local DB.
  static Future<List<Edition>> downloadEditions() async {
    List<Edition> editions = QuranStore._listEditions();
    if (editions.isEmpty) {
      editions = await CloudQuran.listEditions();
      await QuranStore._addEditions(
        editions
            .where(
              (Edition element) =>
                  !_unsupportedTextEditions.contains(element.identifier),
            )
            .toList(),
      );
    }
    return editions;
  }

  /// Download [TheHolyQuran] of the specified [Edition]
  /// from [alquran cloud](https://alquran.cloud/) and store it in the local DB.
  ///
  ///
  /// Note this will also download the the basmala of this quran
  /// if the [Edition.format] equal [Format.audio].
  static Future<TheHolyQuran> downloadQuran({
    required Edition edition,
    void Function(int, int)? onReceiveProgress,
  }) async {
    TheHolyQuran? quran = QuranStore._getQuran(edition);
    if (quran == null) {
      quran = await CloudQuran.getQuran(
        edition: edition,
        onReceiveProgress: onReceiveProgress,
      );
      QuranStore._addQuran(edition, quran);
    }
    return quran;
  }

  /// Download all meta data of quran from [alquran cloud](https://alquran.cloud/)
  /// and store it in the local DB.
  static Future<QuranMeta> downloadQuranMeta({
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return QuranStore.settings.meta;
    } catch (e) {
      final QuranMeta meta =
          await CloudQuran.getQuranMeta(onReceiveProgress: onReceiveProgress);
      QuranStore.settings.meta = meta;
      return meta;
    }
  }

  /// Check whether there is [TheHolyQuran] quran object with
  /// this [Edition] is stored in the local DB.
  static bool isQuranDownloaded(Edition edition) =>
      QuranStore._getQuran(edition) != null;

  /// Reads [TheHolyQuran] from the local DB
  ///
  /// Note that it will throw [TypeError] for casting null if the
  /// quran isn't yet downloaded.
  /// To check whether it's downloaded or not use [isQuranDownloaded].
  static TheHolyQuran getQuran(Edition edition) =>
      QuranStore._getQuran(edition)!;

  /// Downloads each of the [Surah]'s [Ayah]s audio files.
  ///
  /// This method will also merge the [Ayah]s audio file into
  /// one [mergedSurahFileName] file that plays in the player
  /// and save the duration of each ayah to add a positions
  /// facilites to the player.
  /// Note that [onAyahDownloaded] parameter only notifies when a specific ayah
  /// is downloaded completely.
  static Future<void> downloadSurah({
    required Edition edition,
    required Surah surah,
    Function(int index)? onAyahDownloaded,
  }) =>
      CloudQuran.downloadSurah(
        edition: edition,
        surah: surah,
        onAyahDownloaded: onAyahDownloaded,
      );

  /// Check wether the specified [Surah] of the specified [Edition]
  /// is downloaded and is prepared properly.
  static Future<bool> isSurahDownloaded(Edition edition, Surah surah) =>
      QuranStore._isSurahDownloaded(edition, surah);
}
