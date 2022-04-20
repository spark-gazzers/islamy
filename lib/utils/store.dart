import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:path_provider/path_provider.dart';

/// Utility to store all of the user preferences in the local DB
///
///
/// This class uses [Hive] as local DB.
class Store {
  const Store._();
  static late Box<String> _settingsBox;

  /// Intializer for the class which calls [HiveX.initFlutter].
  static Future<void> init() async {
    String subDirForHive = (await getApplicationDocumentsDirectory()).path;
    subDirForHive += '${Platform.pathSeparator}HiveDB';
    await Hive.initFlutter(subDirForHive);
    if (Hive.isBoxOpen('settings')) {
      _settingsBox = Hive.box<String>('settings');
    } else {
      _settingsBox = await Hive.openBox<String>('settings');
    }
    if (!_settingsBox.isOpen) {
      await Hive.openBox<String>(_settingsBox.name);
    }
  }

  static Future<void> _saveValue({
    required String name,
    required String? value,
  }) async {
    await _settingsBox.delete(name);
    if (value != null) await _settingsBox.put(name, value);
  }

  static String? _readValue({required String name}) {
    final String? results = _settingsBox.get(name);
    return results;
  }

  /// The quran font family.
  static String get quranFont =>
      _readValue(name: 'quran_font') ?? 'QuranFont 3';

  static set quranFont(String font) =>
      _saveValue(name: 'quran_font', value: font);

  /// The quran font size.
  static double get quranFontSize =>
      double.parse(_readValue(name: 'quran_font_size') ?? '26.0');

  static set quranFontSize(double size) => _saveValue(
        name: 'quran_font_size',
        value: size.toString(),
      );

  /// The app locale.
  static Locale get locale {
    final String? value = _readValue(name: 'locale');
    if (value == null) {
      return Locale(Intl.defaultLocale ?? Intl.systemLocale);
    }
    return Locale(value);
  }

  static set locale(Locale newLocale) {
    _saveValue(name: 'locale', value: newLocale.toString());
  }

  /// Notifier for changes on the [locale].
  static ValueListenable<Box<dynamic>> get localeListner =>
      _settingsBox.listenable(keys: <String>['locale']);

  /// Wether the app should show notifications or not.
  static bool get muteNotfication =>
      _readValue(name: 'mute_notifications') == '1';

  static set muteNotfication(bool value) {
    _saveValue(name: 'mute_notifications', value: value ? '1' : '0');
  }

  /// Notifier for changes on the [muteNotfication].
  static ValueListenable<Box<dynamic>> get muteNotficationListner =>
      _settingsBox.listenable(keys: <String>['mute_notifications']);

  /// Wether the [QuranPlayerContoller] should read basmala when
  /// playing a single ayah.
  static bool get shouldReadBasmlaOnSelection =>
      (_readValue(name: 'should_read_basmla_on_selection') ?? '1') == '1';

  static set shouldReadBasmlaOnSelection(bool value) {
    _saveValue(
      name: 'should_read_basmla_on_selection',
      value: value ? '1' : '0',
    );
  }

  /// Wether the [QuranPlayerContoller] should read basmala when
  /// playing a single ayah.
  static bool get highlightAyahOnPlayer =>
      (_readValue(name: 'highlight_ayah_on_player') ?? '1') == '1';

  static set highlightAyahOnPlayer(bool value) {
    _saveValue(name: 'highlight_ayah_on_player', value: value ? '1' : '0');
  }

  /// Notifier for changes on the [highlightAyahOnPlayer].
  static ValueListenable<Box<dynamic>> get shouldReadBasmlaOnSelectionListner =>
      _settingsBox
          .listenable(keys: <String>['should_read_basmla_on_selection']);
}
