library helper;

import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

part 'helpers/localization.dart';

class Helper {
  const Helper._();
  static Future<void> init() async {
    await localization.init();
  }

  static const _LocalizationHelper localization = _LocalizationHelper.instance;
}
