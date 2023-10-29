part of hadeeth;

/// The only handler of requests to the host [hadeethenc](https://HadeethEnc.com/).

class CloudHadeeth {
  const CloudHadeeth._();
  static final Dio _dio = Dio();

  ///Intilizer that intlizes the needed properties on the [Dio] object.
  static void init() {
    _dio.options.baseUrl = 'https://hadeethenc.com/api/v1/';
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
        headers: headers,
        validateStatus: (_) => true,
        method: method,
      ),
    );
  }

  /// Fetches all the available [HadeethLanguage] from the host.
  static Future<List<HadeethLanguage>> listLanguages() async {
    final Response<List<dynamic>> response = await _call(path: 'languages');
    return HadeethLanguage.listFrom(
      // it's actually necessary since we need to cast the list not
      // the maps inside!
      // ignore: unnecessary_cast
      (response.data! as List<dynamic>).cast<Map<String, dynamic>>(),
    );
  }

  /// Fetches all the available [HadeethCategory] from the host.
  static Future<List<HadeethCategory>> listCategories() async {
    final Response<List<dynamic>> response = await _call(
        path:
            'categories/list/?language=${HadeethStore.settings.language.code}');
    return HadeethCategory.listFrom(
      // it's actually necessary since we need to cast the list not
      // the maps inside!
      // ignore: unnecessary_cast
      (response.data! as List<dynamic>).cast<Map<String, dynamic>>(),
    );
  }

  /// Fetches all the available [Hadeeth]s in a category.
  static Future<List<Hadeeth>> listHadeeths(HadeethCategory category,
      {HadeethLanguage? language}) async {
    language ??= HadeethStore.settings.language;
    final Response<Map<String, dynamic>> response = await _call(
      path: 'hadeeths/list/?language=${language.code}'
          '&category_id=${category.id}'
          '&per_page=${category.hadeethsCount}',
    );
    if (response.statusCode == 404 &&
        (response.data == null || (response.data as String).trim().isEmpty)) {
      return [];
    }
    return Hadeeth.listFrom(
      (response.data!['data'] as List<dynamic>).cast<Map<String, dynamic>>(),
      language.code,
      category.id,
    );
  }

  /// Fetches a single [HadeethDetails].
  static Future<HadeethDetails> getHadeeth(Hadeeth hadeeth,
      {HadeethLanguage? language}) async {
    language ??= HadeethStore.settings.language;
    final Response<Map<String, dynamic>> response = await _call(
        path: 'hadeeths/one/?language=${language.code}'
            '&id=${hadeeth.id}');

    return HadeethDetails.fromJson(
      response.data as Map<String, dynamic>,
      hadeeth.category!,
      language.code,
    );
  }

  static Future<Map<String, dynamic>> debugHadeeth(
    Hadeeth hadeeth, {
    String? language,
  }) async {
    language ??= hadeeth.languageCode;
    final Response<Map<String, dynamic>> response = await _call(
        path: 'hadeeths/one/?language=${language}'
            '&id=${hadeeth.id}');
    Map<String, dynamic> data = Map<String, dynamic>.from(response.data as Map);
    data['debug_category'] = hadeeth.category;
    data['debug_language'] = language;
    return data;
  }
}
