import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb, defaultTargetPlatform

class ApiService {
  static final Dio _dio = Dio();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Handle localhost for Android Emulator vs others
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api';
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Use specific machine IP to support both Emulator and Physical Device
      return 'http://172.27.175.1:3000/api';
    }
    return 'http://localhost:3000/api';
  }

  static Future<void> init() async {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    
    // Add interceptor to include token in headers
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await _storage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['x-auth-token'] = token;
        }
        return handler.next(options);
      },
    ));
  }

  static String getFileUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;

    // Normalize backslashes to forward slashes for URL compatibility
    String normalizedPath = path.replaceAll(r'\', '/');
    
    // Ensure no leading slash if we are going to append it
    if (normalizedPath.startsWith('/')) {
        normalizedPath = normalizedPath.substring(1);
    }

    if (normalizedPath.startsWith('uploads')) {
      // url = baseUrl (without /api) + / + path
      String root = baseUrl.replaceAll('/api', '');
      
      // Remove trailing slash from root if present
      if (root.endsWith('/')) {
          root = root.substring(0, root.length - 1);
      }
      
      return '$root/$normalizedPath';
    }
    
    return path;
  }

  // Auth Endpoints
  static Future<Response> login(String username, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> register(String fullname, String phone, String gender, String username, String password) async {
    try {
      final response = await _dio.post('/auth/signup', data: {
        'fullname': fullname,
        'phone': phone,
        'gender': gender,
        'username': username,
        'password': password,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> forgotPassword(String username, String newPassword) async {
    try {
      final response = await _dio.post('/auth/forgot-password', data: {
        'username': username,
        'newPassword': newPassword,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> verifyUsername(String username) async {
    try {
      final response = await _dio.post('/auth/verify-username', data: {
        'username': username,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Token Management
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }
    
  static Future<String?> getToken() async {
      return await _storage.read(key: 'jwt_token');
  }

  // Book Endpoints
  static Future<Response> getBooks() async {
    return await _dio.get('/books');
  }

  static Future<Response> addBook(FormData data) async {
    return await _dio.post('/books', data: data);
  }

  static Future<Response> updateBook(String id, FormData data) async {
    return await _dio.put('/books/$id', data: data);
  }

  static Future<Response> deleteBook(String id) async {
    return await _dio.delete('/books/$id');
  }

  // User Endpoints
  static Future<Response> getUsers() async {
    return await _dio.get('/users');
  }

  static Future<Response> addUser(Map<String, dynamic> data) async {
    return await _dio.post('/users', data: data);
  }

  static Future<Response> updateUser(String id, Map<String, dynamic> data) async {
    return await _dio.put('/users/$id', data: data);
  }

  static Future<Response> deleteUser(String id) async {
    return await _dio.delete('/users/$id');
  }

  // Dashboard Endpoints
  static Future<Response> getDashboardStats() async {
    return await _dio.get('/dashboard/stats');
  }

  // Profile Endpoints
  static Future<Response> getProfile() async {
    return await _dio.get('/users/profile');
  }

  static Future<Response> updateProfile(Map<String, dynamic> data) async {
    return await _dio.put('/users/profile', data: data);
  }

  static Future<Response> updateUsername(String newUsername) async {
    return await _dio.put('/users/update-username', data: {
      'newUsername': newUsername
    });
  }

  // Favorites & History
  static Future<Response> addFavorite(String bookId) async {
    return await _dio.post('/users/favorite', data: {'bookId': bookId});
  }

  static Future<Response> removeFavorite(String bookId) async {
    return await _dio.delete('/users/favorites/$bookId');
  }

  static Future<Response> getFavorites() async {
    return await _dio.get('/users/favorites');
  }

  static Future<Response> addToHistory(String bookId) async {
    return await _dio.post('/users/history/$bookId');
  }

  static Future<Response> getHistory() async {
    return await _dio.get('/users/history');
  }
}
