import 'package:flutter/cupertino.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/store/quran_store.dart';
import 'package:islamy/view/auth/enable_location/enable_location.dart';
import 'package:islamy/view/auth/forgot_password/forgot_password.dart';
import 'package:islamy/view/auth/forgot_password/otp.dart';
import 'package:islamy/view/auth/forgot_password/reset_password.dart';
import 'package:islamy/view/auth/login/login.dart';
import 'package:islamy/view/auth/signup/signup.dart';
import 'package:islamy/view/main/main.dart';
import 'package:islamy/view/on_boarding/on_boarding.dart';
import 'package:islamy/view/profile/screens/localization_delegate_screen.dart';
import 'package:islamy/view/profile/screens/quran_settings.dart';
import 'package:islamy/view/profile/screens/select_edition.dart';
import 'package:islamy/view/quran/screens/quran_reader.dart';
import 'package:islamy/view/splash/splash.dart';

class Routes {
  const Routes._();
  static Route onGenerateRoute(RouteSettings settings) {
    WidgetBuilder? builder;
    Map<String, dynamic> args = <String, dynamic>{};
    try {
      args.addAll(
          settings.arguments as Map<String, dynamic>? ?? <String, dynamic>{});
    } finally {}
    switch (settings.name) {
      case 'login':
        builder = (context) => LoginScreen(
              password: args['password'],
              phone: args['phone'],
            );
        break;
      case 'signup':
        builder = (context) => SignupScreen(
              password: args['password'],
              phone: args['phone'],
            );
        break;

      case 'forgot_password':
        builder = (context) => ForgotPasswordScreen(
              phone: args['phone'],
            );
        break;

      case 'reset_password':
        builder = (context) => ResetPasswordScreen(
              phone: args['phone'],
            );
        break;

      case 'otp':
        builder = (context) => OTPScreen(
              phone: args['phone'],
            );
        break;

      case 'select_text_quran':
        builder = (context) => SelectEditionDelegate(
              propertyName: S.current.text_edition,
              selected: QuranStore.settings.defaultTextEdition,
              choices: QuranStore.listTextEditions(),
              onSelected: (edition) {
                QuranStore.settings.defaultTextEdition = edition;
              },
              title: S.current.select_text_edition,
            );
        break;

      case 'select_audio_quran':
        builder = (context) => SelectEditionDelegate(
              propertyName: S.current.audio_edition,
              selected: QuranStore.settings.defaultAudioEdition,
              choices: QuranStore.listAudioEditions(),
              onSelected: (edition) {
                QuranStore.settings.defaultAudioEdition = edition;
              },
              title: S.current.select_audio_edition,
            );
        break;

      case 'select_interpretation_quran':
        builder = (context) => SelectEditionDelegate(
              propertyName: S.current.interpretation_edition,
              selected: QuranStore.settings.defaultInterpretationEdition,
              choices: QuranStore.listInterpretationEditions(),
              onSelected: (edition) {
                QuranStore.settings.defaultInterpretationEdition = edition;
              },
              title: S.current.select_interpretation_edition,
            );
        break;

      case 'select_translation_quran':
        builder = (context) => SelectEditionDelegate(
              propertyName: S.current.translation_edition,
              selected: QuranStore.settings.defaultTranslationEdition,
              choices: QuranStore.listTranslationEditions(),
              onSelected: (edition) {
                QuranStore.settings.defaultTranslationEdition = edition;
              },
              title: S.current.select_translation_edition,
            );
        break;
      case 'select_transliteration_quran':
        builder = (context) => SelectEditionDelegate(
              propertyName: S.current.transliteration_edition,
              selected: QuranStore.settings.defaultTranslationEdition,
              choices: QuranStore.listTransliterationEditions(),
              onSelected: (edition) {
                QuranStore.settings.defaultTranslationEdition = edition;
              },
              title: S.current.select_translation_edition,
            );
        break;
      case 'surah_reader_screen':
        builder = (context) => QuranSurahReader(
              surah: args['surah'],
              edition: args['edition'],
              ayah: args['ayah'],
            );
        break;
      default:
    }
    return _buildRoute(settings, builder);
  }

  static Route _buildRoute(RouteSettings settings, WidgetBuilder? builder) =>
      CupertinoPageRoute(
        builder: builder ?? _routes[settings.name]!,
        settings: settings,
        fullscreenDialog:
            (settings.arguments as Map?)?['fullscreenDialog'] ?? false,
      );
  // static Route
  static Map<String, WidgetBuilder> get _routes => <String, WidgetBuilder>{
        'splash': (_) => const SplashScreen(),
        'on_boarding': (_) => const OnBoarding(),
        'enable_location': (_) => const EnableLocation(),
        'main': (_) => const MainPage(),
        'select_language': (_) => const LocalizationDelegateScreen(),
        'quran_settings': (_) => const QuranSettingsScreen(),
      };
}
