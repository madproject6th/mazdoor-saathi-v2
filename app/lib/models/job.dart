import '../core/utils/helpers.dart';

/// A construction job / project posted by a builder.
class Job {
  final String id;
  final String builderId;
  final String builderName;
  final String title;
  final String description;
  final String siteName;
  final String city;
  final double? lat;
  final double? lng;
  final String status;
  final Map<String, int> requiredTeam; // trade -> count
  final List<String> assignedTeamIds;
  final double? dailyWage;
  final double? budget;
  final String startDate;
  final String endDate;
  final DateTime? createdAt;

  const Job({
    required this.id,
    this.builderId = '',
    this.builderName = '',
    required this.title,
    this.description = '',
    this.siteName = '',
    this.city = '',
    this.lat,
    this.lng,
    this.status = 'posted',
    this.requiredTeam = const {},
    this.assignedTeamIds = const [],
    this.dailyWage,
    this.budget,
    this.startDate = '',
    this.endDate = '',
    this.createdAt,
  });

  bool get hasLocation => lat != null && lng != null;
  int get requiredCount => requiredTeam.values.fold(0, (a, b) => a + b);

  factory Job.fromJson(Map<String, dynamic> j) {
    final loc = j['location'];
    double? lat = (j['lat'] as num?)?.toDouble();
    double? lng = (j['lng'] as num?)?.toDouble();
    if (loc is Map) {
      lat = (loc['lat'] as num?)?.toDouble() ?? lat;
      lng = (loc['lng'] as num?)?.toDouble() ?? lng;
    }
    final team = <String, int>{};
    final rt = j['requiredTeam'] ?? j['tradesRequired'];
    if (rt is Map) {
      rt.forEach((k, v) => team[k.toString()] = (v as num?)?.toInt() ?? 0);
    } else if (rt is List) {
      for (final t in rt) {
        if (t is Map) {
          // Backend shape: [{trade: 'mason', count: 2}, ...]
          final trade = (t['trade'] ?? '').toString();
          if (trade.isEmpty) continue;
          team[trade] = (t['count'] as num?)?.toInt() ?? 1;
        } else {
          team[t.toString()] = (team[t.toString()] ?? 0) + 1;
        }
      }
    }
    return Job(
      id: (j['id'] ?? '').toString(),
      builderId: (j['builderId'] ?? '').toString(),
      builderName: (j['builderName'] ?? '').toString(),
      title: (j['title'] ?? 'Untitled job').toString(),
      description: (j['description'] ?? '').toString(),
      siteName: (j['siteName'] ?? j['address'] ?? '').toString(),
      city: (j['city'] ?? '').toString(),
      lat: lat,
      lng: lng,
      status: (j['status'] ?? 'posted').toString(),
      requiredTeam: team,
      assignedTeamIds:
          (j['assignedTeamIds'] as List?)?.map((e) => e.toString()).toList() ??
              const [],
      dailyWage: (j['dailyWage'] as num?)?.toDouble(),
      budget: (j['budget'] as num?)?.toDouble(),
      startDate: (j['startDate'] ?? '').toString(),
      endDate: (j['endDate'] ?? '').toString(),
      createdAt: parseApiDate(j['createdAt']),
    );
  }
}

/// Skill-match result for one worker against one job.
class MatchResult {
  final UserProfileRef worker;
  final double score;
  final double? distanceKm;
  final List<String> matchedTrades;

  const MatchResult({
    required this.worker,
    this.score = 0,
    this.distanceKm,
    this.matchedTrades = const [],
  });

  factory MatchResult.fromJson(Map<String, dynamic> j) {
    final w = j['worker'] ?? j['profile'] ?? j;
    return MatchResult(
      worker: UserProfileRef.fromJson(asMap(w)),
      score: ((j['score'] ?? j['matchScore']) as num?)?.toDouble() ?? 0,
      distanceKm: (j['distanceKm'] as num?)?.toDouble(),
      matchedTrades:
          (j['matchedTrades'] as List?)?.map((e) => e.toString()).toList() ??
              const [],
    );
  }
}

/// Lightweight reference kept separate to avoid a circular import.
class UserProfileRef {
  final String id;
  final String name;
  final List<String> trades;
  final double ratingAvg;
  final int ratingCount;
  final double? dailyWage;
  final String city;

  const UserProfileRef({
    required this.id,
    required this.name,
    this.trades = const [],
    this.ratingAvg = 0,
    this.ratingCount = 0,
    this.dailyWage,
    this.city = '',
  });

  factory UserProfileRef.fromJson(Map<String, dynamic> j) => UserProfileRef(
        id: (j['id'] ?? j['uid'] ?? '').toString(),
        name: (j['name'] ?? '').toString(),
        trades: (j['trades'] as List?)?.map((e) => e.toString()).toList() ??
            const [],
        ratingAvg: (j['ratingAvg'] as num?)?.toDouble() ?? 0,
        ratingCount: (j['ratingCount'] as num?)?.toInt() ?? 0,
        dailyWage: (j['dailyWage'] as num?)?.toDouble(),
        city: (j['city'] ?? '').toString(),
      );
}
