import 'package:dio/dio.dart';

class ApiHandler {
  const ApiHandler._();
  static final Dio _dio = Dio();
  static void init() {
    _dio.options.baseUrl = '';
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  static Future<Response<dynamic>> _call({
    required String path,
    Map<String, String> headers = const <String, String>{},
    Map<String, dynamic> query = const <String, dynamic>{},
    Map<String, dynamic> body = const <String, dynamic>{},
    String method = 'POST',
  }) {
    return _dio.request<dynamic>(
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
}
