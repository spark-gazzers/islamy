import 'package:flutter/cupertino.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_category.dart';
import 'package:islamy/engines/hadeeth/models/hadeeth_language.dart';
import 'package:islamy/engines/quran/models/ayah.dart';
import 'package:islamy/engines/quran/models/bookmark.dart';
import 'package:islamy/engines/quran/models/edition.dart';
import 'package:islamy/engines/quran/models/surah.dart';
import 'package:islamy/engines/quran/quran_manager.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/view/auth/enable_location/enable_location.dart';
import 'package:islamy/view/auth/forgot_password/forgot_password.dart';
import 'package:islamy/view/auth/forgot_password/otp.dart';
import 'package:islamy/view/auth/forgot_password/reset_password.dart';
import 'package:islamy/view/auth/login/login.dart';
import 'package:islamy/view/auth/signup/signup.dart';
import 'package:islamy/view/hadeeth/hadeeth_categories_screen.dart';
import 'package:islamy/view/hadeeth/hadeeth_search.dart';
import 'package:islamy/view/hadeeth/hadeeths_screen.dart';
import 'package:islamy/view/main/main.dart';
import 'package:islamy/view/on_boarding/on_boarding.dart';
import 'package:islamy/view/profile/screens/localization_delegate_screen.dart';
import 'package:islamy/view/profile/screens/quran_settings.dart';
import 'package:islamy/view/profile/screens/select_edition.dart';
import 'package:islamy/view/quran/screens/quran_reader.dart';
import 'package:islamy/view/splash/splash.dart';

/// The sole manager of the app [Route<T>]s.
class Routes {
  const Routes._();

  /// Builds the necessary route from the [settings].
  ///
  /// Throws [TypeError] for casting null if the the [RouteSettings.name]
  /// is not registered.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    WidgetBuilder? builder;
    final Map<String, dynamic> args = <String, dynamic>{};
    try {
      args.addAll(
        settings.arguments as Map<String, dynamic>? ?? <String, dynamic>{},
      );
    } finally {}
    switch (settings.name) {
      case 'login':
        builder = (BuildContext context) => LoginScreen(
              password: args['password'] as String,
              phone: args['phone'] as String,
            );
        break;
      case 'signup':
        builder = (BuildContext context) => SignupScreen(
              password: args['password'] as String,
              phone: args['phone'] as String,
            );
        break;

      case 'forgot_password':
        builder = (BuildContext context) => ForgotPasswordScreen(
              phone: args['phone'] as String,
            );
        break;

      case 'reset_password':
        builder = (BuildContext context) => ResetPasswordScreen(
              phone: args['phone'] as String,
            );
        break;

      case 'otp':
        builder = (BuildContext context) => OTPScreen(
              phone: args['phone'] as String,
            );
        break;

      case 'hadeeth_category':
        builder = (BuildContext context) => HadeethCategoryScreen(
              category: args['category'] as HadeethCategory?,
              language: args['language'] as HadeethLanguage?,
            );
        break;

      case 'hadeeths_screen':
        builder = (BuildContext context) => HadeethsScreen(
              category: args['category'] as HadeethCategory,
            );
        break;

      case 'hadeeths_search':
        builder = (BuildContext context) => SearchScreen(
              scope: args['scope'] as HadeethCategory?,
            );
        break;

      case 'select_text_quran':
        builder = (BuildContext context) => SelectEditionDelegate(
              propertyName: S.current.script_edition,
              selected: QuranStore.settings.defaultTextEdition,
              choices: QuranStore.listTextEditions(),
              onSelected: (Edition? edition) {
                QuranStore.settings.defaultTextEdition = edition!;
              },
              title: S.current.select_script_edition,
              allowToDisable: false,
            );
        break;

      case 'select_audio_quran':
        builder = (BuildContext context) => SelectEditionDelegate(
              propertyName: S.current.audio_edition,
              selected: QuranStore.settings.defaultAudioEdition,
              choices: QuranStore.listAudioEditions(),
              onSelected: (Edition? edition) {
                QuranStore.settings.defaultAudioEdition = edition!;
              },
              title: S.current.select_audio_edition,
              allowToDisable: false,
            );
        break;

      case 'select_interpretation_quran':
        builder = (BuildContext context) => SelectEditionDelegate(
              propertyName: S.current.interpretation_edition,
              selected: QuranStore.settings.defaultInterpretationEdition,
              choices: QuranStore.listInterpretationEditions(),
              onSelected: (Edition? edition) {
                QuranStore.settings.defaultInterpretationEdition = edition;
              },
              title: S.current.select_interpretation_edition,
            );
        break;

      case 'select_translation_quran':
        builder = (BuildContext context) => SelectEditionDelegate(
              propertyName: S.current.translation_edition,
              selected: QuranStore.settings.defaultTranslationEdition,
              choices: QuranStore.listTranslationEditions(),
              onSelected: (Edition? edition) {
                QuranStore.settings.defaultTranslationEdition = edition;
              },
              title: S.current.select_translation_edition,
            );
        break;
      case 'select_transliteration_quran':
        builder = (BuildContext context) => SelectEditionDelegate(
              propertyName: S.current.transliteration_edition,
              selected: QuranStore.settings.defaultTransliterationEdition,
              choices: QuranStore.listTransliterationEditions(),
              onSelected: (Edition? edition) {
                QuranStore.settings.defaultTransliterationEdition = edition;
              },
              title: S.current.select_translation_edition,
            );
        break;
      case 'surah_reader_screen':
        builder = (BuildContext context) => QuranSurahReader(
              surah: args['surah'] as Surah,
              ayah: args['ayah'] as Ayah?,
            );
        break;

      case 'surah_reader_screen_from_bookmark':
        builder = (BuildContext context) => QuranSurahReader.fromBookMark(
              bookmark: args['bookmark'] as Bookmark,
            );
        break;
      default:
    }
    return _buildRoute(settings, builder);
  }

  static Route<dynamic> _buildRoute(
    RouteSettings settings,
    WidgetBuilder? builder,
  ) =>
      CupertinoPageRoute<dynamic>(
        builder: builder ?? _routes[settings.name]!,
        settings: settings,
        fullscreenDialog: (settings.arguments
                as Map<String, dynamic>?)?['fullscreenDialog'] as bool? ??
            false,
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
