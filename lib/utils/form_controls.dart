// ignore_for_file: body_might_complete_normally_nullable

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/quran_manager.dart';

/// Mixin that contains all of the needed [TextFormField] validators
/// and automation for necessary properties.
///
/// All of the validators here starts by checking if the text is null or empty.
mixin FormControls<T extends StatefulWidget> on State<T> {
  /// All of the current [TextEditingController]s.
  ///
  /// Note calling the [] on this map will always return not
  /// null [TextEditingController] and will dispose them all
  /// in the [dispose] method.
  final Map<String, TextEditingController> controllers =
      _ObjectMap<TextEditingController>(
    map: <String, TextEditingController>{},
    create: TextEditingController.new,
  );

  /// All of the current [FocusNode]s.
  ///
  /// Note calling the [] on this map will always return not
  /// null [FocusNode] and will dispose them all
  /// in the [dispose] method.
  final Map<String, FocusNode> nodes = _ObjectMap<FocusNode>(
    map: <String, FocusNode>{},
    create: FocusNode.new,
  );

  /// The [Form] key premade.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? _emptyValidator(String? str, String name) {
    if (str?.isEmpty ?? true) return S.of(context).required_field(name);
  }

  /// Starting validator only validates against nullability and
  /// if it's [int.parse]able and the length of the otp.
  String? otpValidator(String? str, [int length = 4]) {
    final String? empty = _emptyValidator(str, S.of(context).otp_code);
    if (empty != null) return empty;
    if (int.tryParse(str!) == null) {
      return S.current.invalid_field(S.of(context).otp_code);
    }
    if (str.length < length) {
      return S.current.field_unlengthed(S.of(context).otp_code, length);
    }
  }

  /// Validated the length of the name, must be not less than 8.
  String? nameValidator(String? str) {
    final String? empty = _emptyValidator(str, S.of(context).full_name);
    if (empty != null) return empty;
    if (str!.length < 8) {
      return S.of(context).field_not_less(S.of(context).full_name, 8);
    }
  }

  /// Validated the given phone [str] that must match
  /// a valid 10 digits phone number.
  // TODO(psyonixFx): support for global phone numbers
  // EMPHASIS ON BEFORE LAUNCH.
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

  /// Validated the length of the password, must be not less than 8.
  String? passwordValidator(String? str) {
    final String? empty = _emptyValidator(str, S.of(context).password);
    if (empty != null) return empty;
    if (str!.length < 8) {
      return S.of(context).field_not_less(S.of(context).password, 8);
    }
  }

  /// Validated the length of the password, must be not less than 8 and
  /// it must be equal to the provided paddword.
  String? passwordConfirmationValidator(String? str, String password) {
    final String? empty = _emptyValidator(str, S.of(context).password);
    if (empty != null) return empty;
    if (str!.length < 8) {
      return S.of(context).field_not_less(S.of(context).password, 8);
    }
    if (str != password) return S.current.passwords_dont_match;
  }

  /// Check whether the provided String is a valid double string
  /// and if the value is between [QuranStore.minFontSize] and
  /// [QuranStore.maxFontSize].
  String? fontSizeValidator(String? str) {
    final String? empty = _emptyValidator(str, S.of(context).password);
    if (empty != null) return empty;
    final double? size = double.tryParse(str!);
    if (size == null) {
      return S.of(context).please_enter_a_valid_number;
    }
    if (size > QuranStore.maxFontSize) {
      return S
          .of(context)
          .font_size_must_not_exceed_max(QuranStore.maxFontSize);
    }
    if (size < QuranStore.minFontSize) {
      return S
          .of(context)
          .font_size_must_not_be_less_than_min(QuranStore.minFontSize);
    }
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
