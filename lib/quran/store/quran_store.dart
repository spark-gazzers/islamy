import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:islamy/quran/models/enums_values.dart';
import 'package:islamy/quran/models/sajda.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/text_quran.dart';
import 'package:path_provider/path_provider.dart';

class QuranStore {
  const QuranStore._();
  static const _QuranStoreSettings settings = _QuranStoreSettings.instance;

  static late final Box<Edition> _editionsBox;
  static late final Box<TheHolyQuran> _textQuranBox;
  static Future<void> init() async {
    await _QuranStoreSettings._init();
    _registerAdapters();
    _editionsBox = await _getBox('editions');
    _textQuranBox = await _getBox('text_quran');
  }

  static void _registerAdapters() {
    // Quran adapters typeId should start from 0

    // typeId == 0
    Hive.registerAdapter(EditionAdapter());

    // typeId == 1
    Hive.registerAdapter(EnumValuesAdapter());

    // typeId == 2
    Hive.registerAdapter(QuranContentTypeAdapter());

    // typeId == 3
    Hive.registerAdapter(FormatAdapter());

    // typeId == 4
    Hive.registerAdapter(DirectionAdapter());

    // typeId == 5
    Hive.registerAdapter(TheHolyQuranAdapter());

    // typeId == 6
    Hive.registerAdapter(SurahAdapter());

    // typeId == 7
    Hive.registerAdapter(AyahAdapter());

    // typeId == 8
    Hive.registerAdapter(SajdaAdapter());

    // typeId == 9
    Hive.registerAdapter(RevelationTypeAdapter());
  }

  static Future<Box<T>> _getBox<T>(String boxName) async {
    Box<T> box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<T>(boxName);
    } else {
      box = await Hive.openBox<T>(boxName);
    }

    if (!box.isOpen) {
      await Hive.openBox(box.name);
    }
    return box;
  }

  static List<Edition> listEditions() => _listBoxData(_editionsBox);
  static Future<void> addEditions(List<Edition> editions) =>
      _addAll(values: editions, box: _editionsBox);

  static Future<bool> isSurahDownloaded(TheHolyQuran quran, Surah surah) async {
    Directory surahDirectory = await getDirectoryForSurah(quran, surah);

    return surahDirectory.listSync().length == surah.ayahs.length;
  }

  static Future<Directory> getDirectoryForSurah(
      TheHolyQuran quran, Surah surah) async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    Directory quranDirectory =
        _getDescendant(docDirectory, quran.edition.identifier);
    Directory surahDirectory =
        _getDescendant(quranDirectory, surah.number.toString());
    return surahDirectory;
  }

  static Directory _getDescendant(Directory directory, String child) {
    if (!directory.existsSync()) directory.createSync();
    String path = directory.absolute.path;
    if (!path.endsWith('/')) path += '/';
    Directory descendant = Directory(path + child);
    if (!descendant.existsSync()) descendant.createSync();
    return descendant;
  }

  static TheHolyQuran? getQuran(Edition edition) {
    return _readValue(name: edition.identifier, box: _textQuranBox);
  }

  static Future<void> addQuran(Edition edition, TheHolyQuran quran) async {
    await _saveValue(
        name: edition.identifier, value: quran, box: _textQuranBox);
  }

  static Future<void> _saveValue<T>({
    required String name,
    required T? value,
    required Box<T?> box,
  }) async {
    await box.delete(name);
    await box.put(name, value);
  }

  static Future<void> _addValue<T>({
    required T value,
    required Box<T> box,
  }) async {
    await box.add(value);
  }

  static Future<void> _addAll<T>({
    required List<T> values,
    required Box<T> box,
  }) async {
    await box.addAll(values);
  }

  static T? _readValue<T>({
    required String name,
    required Box<T> box,
  }) {
    T? results = box.get(name);
    return results;
  }

  static List<T> _listBoxData<T>(Box<T> box) => box.values.toList();
}

class _QuranStoreSettings {
  const _QuranStoreSettings._();
  static const _QuranStoreSettings instance = _QuranStoreSettings._();
  static late final Box<dynamic> _settingsBox;
  static Future<void> _init() async {
    _settingsBox = await QuranStore._getBox('quran_settings');
  }

  Edition get defaultTextEdition {
    List<Edition> editions = QuranStore.listEditions()
        .where((element) => element.format == Format.text)
        .toList();
    return _settingsBox.get('default_text_edition') ??
        editions.singleWhere(
          (element) => element.identifier == 'quran-uthmani',
        );
  }

  Future<void> setdefaultTextEdition(Edition edition) async {
    await QuranStore._saveValue(
        name: 'default_text_edition',
        value: edition.identifier,
        box: _settingsBox);
  }

  Edition get defaultAudioEdition {
    List<Edition> editions = QuranStore.listEditions()
        .where((element) => element.format == Format.audio)
        .toList();
    return _settingsBox.get('default_audio_edition') ?? editions.first;
  }

  Future<void> setdefaultAudioEdition(Edition edition) async {
    await QuranStore._saveValue(
        name: 'default_audio_edition',
        value: edition.identifier,
        box: _settingsBox);
  }
}
