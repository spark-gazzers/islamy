// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:islamy/quran/models/text_quran.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/quran/repository/cloud_quran.dart';
import 'package:islamy/quran/store/quran_store.dart';
import 'package:islamy/utils/api/api_handler.dart';
import 'package:islamy/utils/store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Store.init();
  ApiHandler.init();
  await QuranManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Test(),
    );
  }
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material App Bar'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            List<Edition> editions = await QuranManager.listEditions();

            // for (var edition in editions) {
            //   if (edition.format == Format.audio &&
            //       (edition.type != QuranContentType.quran ||
            //           edition.type != QuranContentType.versebyverse)) {
            //     print('identifier : ${edition.identifier}');
            //     print('name : ${edition.name}');
            //     print('type : ${edition.type}');
            //     print('\n\n');
            //   }
            // }
            // print('done');
            // final audio = editions
            //     .firstWhere((element) => element.format == Format.audio);
            TheHolyQuran quran = await QuranManager.getQuran(
                edition: editions.singleWhere((element) =>
                    element.identifier == 'ar.abdulbasitmurattal'));
            // print('finished');
            // print(
            //     await QuranStore.isSurahDownloaded(quran, quran.surahs.first));
            // await CloudQuran.downloadSurah(
            //     quran: quran,
            //     surah: quran.surahs.first,
            //     onAyahDownloaded: (index) {
            //       print(
            //           'downloaded : $index/${quran.surahs.first.ayahs.length}');
            //     });
            await QuranManager.playSurah(quran, quran.surahs.first);
            // print(
            //     await QuranStore.isSurahDownloaded(quran, quran.surahs.first));
          },
          child: Text('Hit Test'),
        ),
      ),
    );
  }
}
