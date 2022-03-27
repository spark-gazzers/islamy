import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:islamy/generated/l10n/l10n.dart';

class Store {
  const Store._();
  static late Box<String> _settingsBox;
  static Future<void> init() async {
    await Hive.initFlutter();
    if (Hive.isBoxOpen('settings')) {
      _settingsBox = Hive.box<String>('settings');
    } else {
      _settingsBox = await Hive.openBox<String>('settings');
    }
    if (!_settingsBox.isOpen) {
      await Hive.openBox(_settingsBox.name);
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
    String? results = _settingsBox.get(name);
    return results;
  }

  static Locale get locale {
    String? value = _readValue(name: 'locale');
    if (value == null) {
      return Locale(Intl.defaultLocale ?? Intl.systemLocale);
    }
    return Locale(value);
  }

  static set locale(Locale newLocale) {
    _saveValue(name: 'locale', value: newLocale.toString());
  }

  static ValueListenable<Box<dynamic>> get localeListner =>
      _settingsBox.listenable(keys: ['locale']);

  static bool get muteNotfication =>
      _readValue(name: 'mute_notifications') == '1';

  static set muteNotfication(bool value) {
    _saveValue(name: 'mute_notifications', value: value ? '1' : '0');
  }

  static ValueListenable<Box<dynamic>> get muteNotficationListner =>
      _settingsBox.listenable(keys: ['mute_notifications']);

  static bool get shouldReadBasmlaOnSelection =>
      (_readValue(name: 'should_read_basmla_on_selection') ?? '1') == '1';

  static set shouldReadBasmlaOnSelection(bool value) {
    _saveValue(
        name: 'should_read_basmla_on_selection', value: value ? '1' : '0');
  }

  static ValueListenable<Box<dynamic>> get shouldReadBasmlaOnSelectionListner =>
      _settingsBox.listenable(keys: ['should_read_basmla_on_selection']);
}
