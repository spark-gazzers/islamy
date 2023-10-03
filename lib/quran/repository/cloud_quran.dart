part of quran;

/// The only handler of requests to the host [alquran cloud](https://alquran.cloud/).

class CloudQuran {
  const CloudQuran._();
  static final Dio _dio = Dio();

  ///Intilizer that creates intlizes the needed properties on the [Dio] object.
  static void init() {
    _dio.options.baseUrl = 'https://api.alquran.cloud/v1/';
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  static Future<Response<T>> _call<T>({
    required String path,
    Map<String, String> headers = const <String, String>{},
    Map<String, dynamic> query = const <String, dynamic>{},
    Map<String, dynamic> body = const <String, dynamic>{},
    void Function(int, int)? onReceiveProgress,
    String method = 'GET',
  }) {
    return _dio.request<T>(
      path,
      data: body,
      queryParameters: query,
      onReceiveProgress: onReceiveProgress,
      options: Options(
        receiveTimeout: Duration.zero,
        sendTimeout: Duration.zero,
        headers: headers,
        validateStatus: (_) => true,
        method: method,
      ),
    );
  }

  /// Fetches all the available [Edition] from the host.
  static Future<List<Edition>> listEditions() async {
    final Response<Map<String, dynamic>> response =
        await _call(path: 'edition');
    return Edition.listFrom(
      (response.data!['data'] as List<dynamic>).cast<Map<String, dynamic>>(),
    );
  }

  /// Fetches specified [TheHolyQuran] using the uniqe
  /// [Edition] id from the host.
  ///
  /// Note this will also download the the basmala of this quran
  /// if the [Edition.format] equal [Format.audio].
  static Future<TheHolyQuran> getQuran({
    required Edition edition,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final Response<Map<String, dynamic>> response =
        await _call<Map<String, dynamic>>(
      path: 'quran/${edition.identifier}',
      onReceiveProgress: onReceiveProgress,
    );
    final TheHolyQuran quran = TheHolyQuran.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
    if (edition.format == Format.audio) {
      final Directory directory =
          await QuranStore._getDirectoryForSurah(edition, quran.surahs.first);
      await downloadAyah(directory, quran.surahs.first.ayahs.first);
    }
    return quran;
  }

  /// Fetches all of the quran meta.
  static Future<QuranMeta> getQuranMeta({
    void Function(int, int)? onReceiveProgress,
  }) async {
    final Response<Map<String, dynamic>> response =
        await _call<Map<String, dynamic>>(
      path: 'meta',
      onReceiveProgress: onReceiveProgress,
    );
    return QuranMeta.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  /// Downloads the specified [Ayah] main audio file and store it in the
  /// provided [directory] using the [Ayah.numberInSurah].mp3 for the file name.
  static Future<void> downloadAyah(Directory directory, Ayah ayah) async {
    String path = directory.path;
    if (!path.endsWith(Platform.pathSeparator)) path += Platform.pathSeparator;
    path += '${ayah.numberInSurah}.mp3';
    await _dio.downloadUri(
      Uri.parse(ayah.audio!),
      path,
    );
  }

  /// Downloads surahs ayahs and prepare it's meta for the player.
  ///
  ///
  /// ## Preperations
  ///
  ///   - Merging all of the audio files into one merged file.
  ///
  ///   - Add basmala to the start if needed.
  ///
  ///   - Creating a positions json file storing all of the ayahs
  ///      audio length as [Duration].
  ///
  ///   - Create a .nomedia file if the device platform supports it.
  ///
  static Future<void> downloadSurah({
    required Edition edition,
    required Surah surah,
    void Function(int)? onAyahDownloaded,
  }) async {
    // the surah directory
    final Directory surahDirectory =
        await QuranStore._getDirectoryForSurah(edition, surah);
    // if there is a fault and this method is called even id the surah is
    // downloaded before for this edition then delete the old one.
    //better safe than sorry.
    for (final FileSystemEntity file in surahDirectory.listSync()) {
      await file.delete(recursive: true);
    }
    // download each ayah
    for (int i = 0; i < surah.ayahs.length; i++) {
      await CloudQuran.downloadAyah(surahDirectory, surah.ayahs[i]);
      onAyahDownloaded?.call(i);
    }
    final List<FileSystemEntity> files = surahDirectory.listSync()
      // sort the ayahs files by number
      ..sort(
        (FileSystemEntity f1, FileSystemEntity f2) =>
            f1.path.compareTo(f2.path),
      );
    // creating the merged surah file
    final File merged = File(
      surahDirectory.path +
          Platform.pathSeparator +
          QuranManager.mergedSurahFileName,
    );

    // the duration map to be later a json which will be used in the player
    final Map<String, int> durations = <String, int>{};
    // making a seperate list to use later on the merger
    final List<File> ayahsFiles = <File>[];
    // iterating for each file in the directory append it
    // to the merged surah list
    for (final FileSystemEntity item in files) {
      // item is file && is audio but not the merged file
      if (item is File &&
          item.path.split('.').last == 'mp3' &&
          item.path.split(Platform.pathSeparator).last !=
              QuranManager.mergedSurahFileName) {
        // add the ayah to the merged list
        ayahsFiles.add(item);
        // adding the duration with the file name to the durations map
        durations[item.path
                .split(Platform.pathSeparator)
                .last
                .replaceFirst('.mp3', '')] =
            (await QuranPlayerContoller.lengthOf(item.path)).inMicroseconds;
      }
    }
    // start by calculating if the surah needs basmala
    // add basmala at the start only if the surah is not
    // ٱلْفَاتِحَة cause it's already included at the first
    // neither ٱلتَّوْبَة cause it's starts without it.
    final TheHolyQuran quran = QuranStore._getQuran(edition)!;
    final bool needsBasmala = surah.number != 1 && surah.number != 9;
    final File basmala = await QuranStore._basmalaFileFor(quran);
    int ayahNumer(File file) {
      String name = file.path.split(Platform.pathSeparator).last;
      name = name.split('.').first;
      return int.parse(name);
    }

    ayahsFiles
        .sort((File f1, File f2) => ayahNumer(f1).compareTo(ayahNumer(f2)));
    if (needsBasmala) {
      ayahsFiles.insert(0, basmala);
    }
    await _concatenate(ayahsFiles, merged);
    // the duration json file
    final File durationsJson = File(
      surahDirectory.path +
          Platform.pathSeparator +
          QuranManager.durationJsonFileName,
    );
    // adding the basmala duration if it was added before
    if (needsBasmala) {
      durations['0'] =
          (await QuranPlayerContoller.lengthOf(basmala.path)).inMicroseconds;
    }
    // write the durations map to the json file
    durationsJson.writeAsStringSync(
      json.encode(durations),
      mode: FileMode.write,
      flush: true,
    );
    // if the platform supports no media file append it
    if (QuranManager.noMediaPlatforms.contains(Platform.operatingSystem)) {
      File('${surahDirectory.path}${Platform.pathSeparator}.nomedia')
          .createSync();
    }
  }

  /// coppied from SO [answer](https://stackoverflow.com/a/66528374/18150607) and modifed to seperated files instead of assets
  static Future<File> _concatenate(List<File> ayahs, File output) async {
    final File list = File(
      '${output.path.substring(
        0,
        output.path.lastIndexOf(Platform.pathSeparator) + 1,
      )}list.txt',
    );
    for (final File ayah in ayahs) {
      list.writeAsStringSync('file ${ayah.path}\n', mode: FileMode.append);
    }

    final List<String> cmd = <String>[
      '-f',
      'concat',
      '-safe',
      '0',
      '-y',
      '-i',
      list.path,
      '-codec',
      'copy',
      output.path
    ];
    final FFmpegSession session = await FFmpegKit.executeWithArguments(cmd);
    final ReturnCode? code = await session.getReturnCode();
    list.deleteSync();
    if (!(code?.isValueSuccess() ?? false)) {
      throw StateError('FFmpegKit failed to ayahs');
    }
    return output;
  }
}
