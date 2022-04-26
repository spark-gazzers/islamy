// ignore_for_file: library_private_types_in_public_api

library helper;

import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

part 'helpers/localization.dart';
part 'helpers/messages.dart';
part 'helpers/formatters.dart';
part 'helpers/translator.dart';

/// Gateway class for all of the app helpers.
class Helper {
  const Helper._();

  /// Intializer that intialize all of the registered helpers.
  static Future<void> init() async {
    await localization.init();
    await formatters.init();
    await translator.init();
  }

  /// Localization Helper that provides localization locales names.
  static const _Localization localization = _Localization.instance;

  /// Messages Helper that facilitates the app inner UI messages.
  static const _Messages messages = _Messages.instance;

  /// Formatters Helper that provides all of the basic formating
  /// for [String],[Duration] ...etc
  static const _Formatters formatters = _Formatters.instance;

  /// Localization Helper that provides localization strings as [Map].
  static const _Translator translator = _Translator.instance;
}
