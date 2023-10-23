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
}
