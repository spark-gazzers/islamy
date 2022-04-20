import 'package:country_code_picker/country_localizations.dart';
import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_min/log_redirection_strategy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/theme.dart';
import 'package:islamy/utils/api/api_handler.dart';
import 'package:islamy/utils/helper.dart';
import 'package:islamy/utils/routes.dart';
import 'package:islamy/utils/store.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  // return live.main();
  runApp(const IslamyApp());
}

/// The main app initializer which loads every static service in the app.
///
/// Note.
/// Depending on the user this can take from 3 seconds upto 7 in somecase cause
/// of the load and the proccess of many [TheHolyQuran] objects.
/// So UX wise, those initializer should never be called outside splash screen
Future<void> init() async {
  await Store.init();
  ApiHandler.init();
  await QuranManager.init();
  await Helper.init();
  FFmpegKitConfig.setLogRedirectionStrategy(
    LogRedirectionStrategy.neverPrintLogs,
  );
}

///The main application [WidgetsApp]
class IslamyApp extends StatelessWidget {
  const IslamyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Islamy App',
      builder: (BuildContext context, Widget? child) => ScrollConfiguration(
        behavior: const CupertinoScrollBehavior(),
        child: Material(
          color: Colors.transparent,
          type: MaterialType.canvas,
          elevation: 0,
          child: child,
        ),
      ),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        S.delegate,
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeBuilder.lightTheme,
      debugShowCheckedModeBanner: false,
      supportedLocales: S.delegate.supportedLocales,
      onGenerateRoute: Routes.onGenerateRoute,
      initialRoute: 'main',
    );
  }
}
