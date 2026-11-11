import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

/// Thrown when backend returns {ok:false} or non-2xx.
class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);
  bool get isNotFound => statusCode == 404;
  bool get isUnauthorized => statusCode == 401;
  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// HTTP wrapper for the Mazdoor Sathi v2 backend.
/// Base URL: --dart-define=API_BASE_URL (default Android emulator loopback).
/// Auth: Firebase ID token Bearer, or `Test <uid>` in demo mode.
class ApiClient {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );

  final http.Client _http;
  String? demoUid;

  ApiClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  Future<Map<String, String>> _headers() async {
    if (demoUid != null) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Test $demoUid',
      };
    }
    String? token;
    try {
      token = await FirebaseAuth.instance.currentUser?.getIdToken();
    } catch (_) {
      token = null;
    }
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  dynamic _unwrap(http.Response res) {
    Map<String, dynamic> body;
    try {
      body = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('Invalid server response', res.statusCode);
    }
    if (res.statusCode >= 200 && res.statusCode < 300 && body['ok'] == true) {
      return body['data'];
    }
    final err = body['error'];
    final msg = err is Map
        ? (err['message']?.toString() ?? 'Request failed')
        : 'Request failed';
    throw ApiException(msg, res.statusCode);
  }

  Future<dynamic> get(String path) async {
    final res = await _http.get(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
    );
    return _unwrap(res);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await _http.post(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _unwrap(res);
  }

  Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    final res = await _http.patch(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _unwrap(res);
  }

  Future<dynamic> delete(String path) async {
    final res = await _http.delete(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
    );
    return _unwrap(res);
  }

  void close() => _http.close();
}
