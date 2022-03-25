// ignore_for_file: body_might_complete_normally_nullable

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';

mixin FormControls<T extends StatefulWidget> on State<T> {
  final Map<String, TextEditingController> controllers =
      _Controllers(<String, TextEditingController>{});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? _emptyValidator(String? str, String name) {
    if (str?.isEmpty ?? true) return S.of(context).required_field(name);
  }

  String? otpValidator(String? str) {
    String? empty = _emptyValidator(str, S.of(context).otp_code);
    if (empty != null) return empty;
    if (int.tryParse(str!) == null) {
      return S.current.invalid_field(S.of(context).otp_code);
    }
    if (str.length < 4) {
      return S.current.field_unlengthed(S.of(context).otp_code, 4);
    }
  }

  String? nameValidator(String? str) {
    String? empty = _emptyValidator(str, S.of(context).full_name);
    if (empty != null) return empty;
    if (str!.length < 8) {
      return S.of(context).field_not_less(S.of(context).full_name, 8);
    }
  }

  String? phoneValidator(String? str) {
    String? empty = _emptyValidator(str, S.of(context).phone_number);
    if (empty != null) return empty;
    if (str!.length != 10) {
      return S.of(context).field_unlengthed(S.of(context).phone_number, 10);
    }
    if (int.tryParse(str) == null) {
      return S.of(context).invalid_field(S.of(context).phone_number);
    }
  }

  String? passwordValidator(String? str) {
    String? empty = _emptyValidator(str, S.of(context).password);
    if (empty != null) return empty;
    if (str!.length < 8) {
      return S.of(context).field_not_less(S.of(context).password, 8);
    }
  }

  String? passwordConfirmationValidator(String? str, String password) {
    String? empty = _emptyValidator(str, S.of(context).password);
    if (empty != null) return empty;
    if (str!.length < 8) {
      return S.of(context).field_not_less(S.of(context).password, 8);
    }
    if (str != password) return S.current.passwords_dont_match;
  }

  @override
  void dispose() {
    for (var entry in controllers.entries) {
      entry.value.dispose();
    }
    super.dispose();
  }
}

class _Controllers extends MapView<String, TextEditingController> {
  _Controllers(Map<String, TextEditingController> map) : super(map);

  @override
  TextEditingController operator [](Object? name) {
    if (!containsKey(name)) {
      super[name as String] = TextEditingController();
    }
    return super[name]!;
  }
}
