import 'dart:math' as math;

import 'package:intl/intl.dart';

/// Small formatting / validation helpers.
class Helpers {
  static final _money = NumberFormat('#,##0');
  static String money(num? v) => 'Rs ${_money.format(v ?? 0)}';
  static String date(DateTime? d) =>
      d == null ? '—' : DateFormat('dd MMM yyyy').format(d);
  static String dateTime(DateTime? d) =>
      d == null ? '—' : DateFormat('dd MMM, h:mm a').format(d);

  static bool isEmail(String v) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
  static bool isPhone(String v) =>
      RegExp(r'^\+?\d{10,15}$').hasMatch(v.replaceAll(' ', ''));

  /// Great-circle distance in km (Haversine).
  static double distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(lat1)) *
            math.cos(_rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  static double _rad(double deg) => deg * math.pi / 180;
}

/// Parses API timestamps: ISO strings, epoch millis, or Firestore
/// Timestamp.toJSON() maps ({_seconds, _nanoseconds} / {seconds, nanoseconds}).
DateTime? parseApiDate(dynamic v) {
  if (v == null) return null;
  if (v is num) return DateTime.fromMillisecondsSinceEpoch(v.toInt());
  if (v is String) return DateTime.tryParse(v);
  if (v is Map) {
    final s = (v['_seconds'] ?? v['seconds']) as num?;
    if (s != null) return DateTime.fromMillisecondsSinceEpoch(s.toInt() * 1000);
  }
  return null;
}

Map<String, dynamic> asMap(dynamic d) =>
    d is Map ? Map<String, dynamic>.from(d) : <String, dynamic>{};
List<Map<String, dynamic>> asMapList(dynamic d) => d is List
    ? d.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
    : <Map<String, dynamic>>[];
