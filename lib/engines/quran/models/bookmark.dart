import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:islamy/engines/quran/models/ayah.dart';
import 'package:islamy/engines/quran/models/surah.dart';
import 'package:islamy/engines/quran/models/the_holy_quran.dart';

part '../../../generated/adapters/quran/bookmark.dart';

@HiveType(typeId: 1)

/// A class that stores the presice location of the quran reader
/// by storing the [Surah] number, the [Ayah] number and the index
/// of the current page opened.
class Bookmark extends HiveObject {
  @protected
  @Deprecated(
    'This constructor is only used by the hive generator and since the\n'
    "generator requiers an unnamed constructor this won't be deleted.",
  )
  Bookmark({
    required this.surah,
    required this.ayah,
    required this.page,
    required this.createdAt,
    required this.message,
  });

  Bookmark.fromPage({
    required this.surah,
    required this.page,
    this.message = '',
    this.ayah,
  }) : createdAt = DateTime.now();

  Bookmark.fromAyah({
    required this.surah,
    required Ayah ayah,
    this.message = '',
  })  : ayah = ayah.number,
        page = ayah.page - 1,
        createdAt = DateTime.now();

  @override
  bool operator ==(Object other) => other is Bookmark && other.key == key;

  @override
  int get hashCode => key.hashCode;

  /// The exact surah number from [Surah.number].
  @HiveField(0)
  final int surah;

  /// The exact ayah number from [Ayah.number].
  @HiveField(1)
  final int? ayah;

  /// The index of the page in [TheHolyQuran.pages] so the UI relevant will be
  /// actually [Ayah.page] -1.
  @HiveField(2)
  final int page;

  /// When the [Bookmark] is created.
  @HiveField(3)
  DateTime createdAt;

  /// An optional message.
  @HiveField(4)
  String message;
}
