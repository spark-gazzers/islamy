// ignore_for_file: body_might_complete_normally_nullable

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';

mixin FormControls on State {
  final Map<String, TextEditingController> controllers =
      _ObjectMap<TextEditingController>(
    map: <String, TextEditingController>{},
    create: TextEditingController.new,
  );

  final Map<String, FocusNode> nodes = _ObjectMap<FocusNode>(
    map: <String, FocusNode>{},
    create: FocusNode.new,
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? _emptyValidator(String? str, String name) {
    if (str?.isEmpty ?? true) return S.of(context).required_field(name);
  }

  String? otpValidator(String? str) {
    final String? empty = _emptyValidator(str, S.of(context).otp_code);
    if (empty != null) return empty;
    if (int.tryParse(str!) == null) {
      return S.current.invalid_field(S.of(context).otp_code);
    }
    if (str.length < 4) {
      return S.current.field_unlengthed(S.of(context).otp_code, 4);
    }
  }

  String? nameValidator(String? str) {
    final String? empty = _emptyValidator(str, S.of(context).full_name);
    if (empty != null) return empty;
    if (str!.length < 8) {
      return S.of(context).field_not_less(S.of(context).full_name, 8);
    }
  }

  String? phoneValidator(String? str) {
    final String? empty = _emptyValidator(str, S.of(context).phone_number);
    if (empty != null) return empty;
    if (str!.length != 10) {
      return S.of(context).field_unlengthed(S.of(context).phone_number, 10);
    }
    if (int.tryParse(str) == null) {
      return S.of(context).invalid_field(S.of(context).phone_number);
    }
  }

  String? passwordValidator(String? str) {
    final String? empty = _emptyValidator(str, S.of(context).password);
    if (empty != null) return empty;
    if (str!.length < 8) {
      return S.of(context).field_not_less(S.of(context).password, 8);
    }
  }

  String? passwordConfirmationValidator(String? str, String password) {
    final String? empty = _emptyValidator(str, S.of(context).password);
    if (empty != null) return empty;
    if (str!.length < 8) {
      return S.of(context).field_not_less(S.of(context).password, 8);
    }
    if (str != password) return S.current.passwords_dont_match;
  }

  @override
  void dispose() {
    (controllers as _ObjectMap<TextEditingController>).dispose();
    (nodes as _ObjectMap<FocusNode>).dispose();
    super.dispose();
  }
}

class _ObjectMap<T extends ChangeNotifier> extends MapView<String, T> {
  _ObjectMap({required Map<String, T> map, required this.create}) : super(map);

  final T Function() create;

  @override
  T operator [](Object? name) {
    if (!containsKey(name)) {
      super[name! as String] = create();
    }
    return super[name]!;
  }

  void dispose() {
    for (final T object in values) {
      object.dispose();
    }
  }
}
