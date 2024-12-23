import 'package:dio/dio.dart';
import 'package:dio/io.dart'; // Tambahkan untuk akses HttpClient
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // Untuk HttpClient

class DioClient {
  final Dio _dio;

  DioClient({required String baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 1000),
          receiveTimeout: const Duration(seconds: 1000),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )) {
    // Tambahkan untuk mengabaikan validasi sertifikat SSL
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true; // Abaikan validasi SSL
      };
      return client;
    };

    // Tambahkan interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await _addAuthorizationHeader(options);
          handler.next(options);
        },
        onError: (DioException error, handler) {
          print("Error occurred: ${error.message}");
          handler.next(error);
        },
      ),
    );
  }

  // Tambahkan token ke header secara lazy
  Future<void> _addAuthorizationHeader(RequestOptions options) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      print("SharedPreferences error: ${e.toString()}");
    }
  }

  Dio get client => _dio;

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(endpoint, queryParameters: queryParams);
  }

  Future<Response> post(String endpoint,
      {dynamic data, Options? options}) async {
    return await _dio.post(endpoint, data: data, options: options);
  }
}
