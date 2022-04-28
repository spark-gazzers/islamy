import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';
import 'package:islamy/quran/quran_manager.dart';

part '../../generated/adapters/quran/book_mark.dart';

@HiveType(typeId: 1)

/// A class that stores the presice location of the quran reader
/// by storing the [Surah] number, the [Ayah] number and the index
/// of the current page opened.
class BookMark extends HiveObject {
  @protected
  @Deprecated(
    'This constructor is only used by the hive generator and since the\n'
    "generator requiers an unnamed constructor this won't be deleted.",
  )
  BookMark({
    required this.surah,
    required this.ayah,
    required this.page,
  });

  BookMark.fromPage({
    required this.surah,
    required this.page,
  }) : ayah = QuranManager.getQuran(QuranStore.settings.defaultTextEdition)
            .surahs
            .singleWhere((Surah element) => element.number == surah)
            .ayahs
            .firstWhere((Ayah element) => element.page == page + 1)
            .number;

  BookMark.fromAyah({
    required this.surah,
    required Ayah ayah,
  })  : ayah = ayah.number,
        page = ayah.page - 1;

  @override
  bool operator ==(Object other) => other is BookMark && other.key == key;

  @override
  int get hashCode => key.hashCode;

  @HiveField(0)

  /// The exact surah number from [Surah.number].
  final int surah;
  @HiveField(1)

  /// The exact ayah number from [Ayah.number].
  final int ayah;
  @HiveField(2)

  /// The index of the page in [TheHolyQuran.pages] so the UI relevant will be
  /// actually [Ayah.page] -1.
  final int page;
}
