import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_min/log_redirection_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/utils/api/api_handler.dart';
import 'package:islamy/utils/helper.dart';
import 'package:islamy/utils/store.dart';

/// The root [Route] screen that loads the static intializers of the app.
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  /// The main app initializer which loads every static service in the app.
  ///
  /// Note.
  /// Depending on the user this can take from 3 seconds upto 7 in somecase
  /// cause of the load and the proccess of many [TheHolyQuran] objects.
  /// So UX wise, those initializer should never be called outside splash screen
  Future<void> init() async {
    final now = DateTime.now();
    await Store.init();
    ApiHandler.init();
    await QuranManager.init();
    await Helper.init();
    FFmpegKitConfig.setLogRedirectionStrategy(
      LogRedirectionStrategy.neverPrintLogs,
    );
    final Duration length = now.difference(DateTime.now()).abs();
    print('done after ${length.inSeconds}');
  }

  // void downloadAll() async {
  //   final List<Edition> all = QuranStore.listAudioEditions();
  //   for (var i = 0; i < all.length; i++) {
  //     await QuranManager.downloadQuran(edition: all[i]);
  //     print('$i out of ${all.length}');
  //   }
  //   print('done');
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return const Material(
      elevation: 0,
      child: Center(
        child: Hero(
          transitionOnUserGestures: true,
          tag: 'logo_hero_tag',
          child: Image(
            height: 150,
            image: AssetImage('assets/images/logo_with_text.png'),
          ),
        ),
      ),
    );
  }
}
