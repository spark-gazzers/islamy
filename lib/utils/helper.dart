library helper;

import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'helpers/localization.dart';
part 'helpers/messages.dart';

class Helper {
  const Helper._();
  static Future<void> init() async {
    await localization.init();
  }

  static const _LocalizationHelper localization = _LocalizationHelper.instance;
  static const _MessagesHelper messages = _MessagesHelper.instance;
}
