import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ambil token secara lazy
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

  // Ubah tipe data agar bisa menerima FormData
  Future<Response> post(String endpoint,
      {dynamic data, Options? options}) async {
    return await _dio.post(endpoint, data: data, options: options);
  }
}



// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DioClient {
//   final Dio _dio;

//   DioClient({required String baseUrl})
//       : _dio = Dio(BaseOptions(
//           baseUrl: baseUrl,
//           connectTimeout: const Duration(seconds: 60),
//           receiveTimeout: const Duration(seconds: 60),
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//           },
//           validateStatus: (status) {
//             // Menonaktifkan validasi status untuk kode selain 2xx
//             return status! < 500; // Menganggap status selain 5xx tidak masalah
//           },
//         )) {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           // Ambil token secara lazy
//           await _addAuthorizationHeader(options);
//           handler.next(options);
//         },
//         onError: (DioException error, handler) {
//           print("Error occurred: ${error.message}");
//           handler.next(error);
//         },
//       ),
//     );
//   }

//   // Tambahkan token ke header secara lazy
//   Future<void> _addAuthorizationHeader(RequestOptions options) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
//       if (token != null) {
//         options.headers['Authorization'] = 'Bearer $token';
//       }
//     } catch (e) {
//       print("SharedPreferences error: ${e.toString()}");
//     }
//   }

//   Dio get client => _dio;

//   Future<Response> get(String endpoint,
//       {Map<String, dynamic>? queryParams, Options? options}) async {
//     // Jika options tidak disediakan, buat options baru
//     options ??= Options();
//     try {
//       final response = await _dio.get(endpoint,
//           queryParameters: queryParams, options: options);

//       // Jika perlu, bisa melakukan pengecekan khusus untuk status tertentu
//       if (response.statusCode == 404) {
//         // Menangani error 404 secara manual
//         throw DioException(
//           type: DioErrorType.badResponse, // Perbaikan konstanta
//           requestOptions: response.requestOptions,
//           response: response, // Sertakan response jika dibutuhkan
//           error: 'Endpoint tidak ditemukan: $endpoint',
//         );
//       }

//       return response;
//     } catch (e) {
//       print("Error occurred: $e");
//       rethrow;
//     }
//   }

//   Future<Response> post(String endpoint,
//       {Map<String, dynamic>? data, Options? options}) async {
//     // Jika options tidak disediakan, buat options baru
//     options ??= Options();
//     return await _dio.post(endpoint, data: data, options: options);
//   }
// }
