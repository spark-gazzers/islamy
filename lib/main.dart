import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:islamy/generated/l10n/l10n.dart';
import 'package:islamy/theme.dart';
import 'package:islamy/utils/routes.dart';

Future<void> main(List<String> args) async {
  // return live.main();
  runApp(const IslamyApp());
}

///The main application [WidgetsApp]
class IslamyApp extends StatelessWidget {
  const IslamyApp({super.key});
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
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeBuilder.lightTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.onGenerateRoute,
      initialRoute: 'splash',
    );
  }
}
