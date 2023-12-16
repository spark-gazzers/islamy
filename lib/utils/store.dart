import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

/// Utility to store all of the user preferences in the local DB
///
///
/// This class uses [Hive] as local DB.
class Store {
  const Store._();
  static late Box<String> _settingsBox;
  static late Box<String> _quranSearchesBox;
  static late Box<String> _hadeethSearchesBox;
  static late Box<double> _hadeethFontsSizeBox;
  static const HadeethFontSize fontsSize = HadeethFontSize._instance;

  /// Intializer for the class which calls [HiveX.initFlutter].
  static Future<void> init() async {
    String subDirForHive = (await getApplicationDocumentsDirectory()).path;
    subDirForHive += '${Platform.pathSeparator}HiveDB';
    await Hive.initFlutter(subDirForHive);
    // _debugClearHive(subDirForHive);
    _settingsBox = await _getBox<String>('settings');
    _quranSearchesBox = await _getBox<String>('quran_search_history');
    _hadeethSearchesBox = await _getBox<String>('hadeeth_search_history');
    _hadeethFontsSizeBox = await _getBox<double>('hadeeth_fonts_size');
  }

  static void _debugClearHive(String path) =>
      Directory(path).deleteSync(recursive: true);

  List<String> get hadeethSearchHistory => _hadeethSearchesBox.values.toList();
  List<String> get quranSearchHistory => _quranSearchesBox.values.toList();

  static Future<void> _addValue<T>(T value, Box<T> box) async {
    box.add(value);
  }

  static Future<void> _addHistoryValue<T>(T value, Box<T> box) async {
    if (box.values.contains(value)) {
      return;
    }
    box.putAt(0, value);
    if (box.length > 10) {
      final Iterable<T> values = box.values.take(10);
      box.clear();
      await box.addAll(values);
    }
  }

  static Future<void> addQuranSearchHistry(String history) =>
      _addHistoryValue(history, _quranSearchesBox);
  static Future<void> addHadeethSearchHistry(String history) =>
      _addHistoryValue(history, _hadeethSearchesBox);

  static Future<Box<T>> _getBox<T>(String boxName) async {
    Box<T> box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<T>(boxName);
    } else {
      box = await Hive.openBox<T>(boxName);
    }

    if (!box.isOpen) {
      await Hive.openBox<T>(box.name);
    }
    return box;
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
}

class HadeethFontSize {
  const HadeethFontSize._();
  static const HadeethFontSize _instance = HadeethFontSize._();
  double? operator [](String name) => Store._hadeethFontsSizeBox.get(name);

  void operator []=(String name, double value) {
    Store._hadeethFontsSizeBox.put(name, value);
  }

  ValueListenable<dynamic> get listenable =>
      Store._hadeethFontsSizeBox.listenable();
}
