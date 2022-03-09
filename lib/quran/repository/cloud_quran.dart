import 'dart:io';

import 'package:dio/dio.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/surah.dart';
import 'package:islamy/quran/models/text_quran.dart';
import 'package:islamy/quran/store/quran_store.dart';

class CloudQuran {
  const CloudQuran._();
  static late final Dio _dio = Dio();
  static void init() {
    _dio.options.baseUrl = 'http://api.alquran.cloud/v1/';
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  static Future<Response> _call({
    required String path,
    Map<String, String> headers = const <String, String>{},
    Map<String, dynamic> query = const <String, dynamic>{},
    Map<String, dynamic> body = const <String, dynamic>{},
    String method = 'GET',
  }) {
    return _dio.request(
      path,
      data: body,
      queryParameters: query,
      options: Options(
        headers: headers,
        validateStatus: (_) => true,
        method: method,
      ),
    );
  }

  static Future<List<Edition>> listEditions() async {
    Response response = await _call(path: 'edition');
    return Edition.listFrom(response.data['data']);
  }

  static Future<TheHolyQuran> getQuran({Edition? edition}) async {
    edition ??= QuranStore.settings.defaultTextEdition;
    Response response = await _call(path: 'quran/${edition.identifier}');
    return TheHolyQuran.fromJson(response.data['data']);
  }

  static Future<void> downloadAyah(Directory directory, Ayah ayah) async {
    String path = directory.absolute.path;
    if (!path.endsWith('/')) path += '/';
    path += ayah.numberInSurah.toString();
    _dio.downloadUri(
      Uri.parse(ayah.audio!),
      path,
    );
  }

  static Future<void> downloadSurah({
    required TheHolyQuran quran,
    required Surah surah,
    Function(int index)? onAyahDownloaded,
  }) async {
    Directory surahDirectory =
        await QuranStore.getDirectoryForSurah(quran, surah);
    surahDirectory.listSync().forEach((element) {
      element.deleteSync();
    });
    for (var i = 0; i < surah.ayahs.length; i++) {
      await CloudQuran.downloadAyah(surahDirectory, surah.ayahs[i]);
      onAyahDownloaded?.call(i);
    }
  }
}
