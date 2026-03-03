import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// API 基礎 URL - 開發環境
// Android emulator 無法直接使用 localhost，需改用 10.0.2.2
String get baseUrl {
  if (kIsWeb) return 'http://localhost:3000';
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return 'http://10.0.2.2:3000';
    default:
      return 'http://localhost:3000';
  }
}

// Secure Storage Provider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// Dio 客戶端 Provider
final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // 新增 Interceptor 用於自動加入 JWT Token
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 從 Secure Storage 讀取 token
        final storage = ref.read(secureStorageProvider);
        final token = await storage.read(key: 'access_token');

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (error, handler) async {
        // 處理 401 未授權錯誤
        if (error.response?.statusCode == 401) {
          // Token 過期或無效，清除本地 token
          final storage = ref.read(secureStorageProvider);
          await storage.delete(key: 'access_token');
          // 可以在這裡觸發導航到登入頁面
        }
        return handler.next(error);
      },
    ),
  );

  // 在開發環境中記錄請求和回應
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ),
  );

  return dio;
});
