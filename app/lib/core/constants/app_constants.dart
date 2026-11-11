/// Shared constants for Mazdoor Sathi v2.
class AppConstants {
  static const String appName = 'Mazdoor Sathi';
  static const String tagline = 'Skilled teams, honest work';

  /// The 8 supported construction trades (backend ids -> display labels).
  static const Map<String, String> trades = {
    'mason': 'Mason',
    'electrician': 'Electrician',
    'plumber': 'Plumber',
    'painter': 'Painter',
    'carpenter': 'Carpenter',
    'tile_worker': 'Tile Worker',
    'welder': 'Welder',
    'laborer': 'General Laborer',
  };

  /// Job lifecycle statuses, in display order (cancelled shown separately).
  static const List<String> jobStatuses = [
    'posted',
    'requested',
    'team_confirmed',
    'started',
    'in_progress',
    'completed',
  ];
  static const List<String> allStatuses = [...jobStatuses, 'cancelled'];

  static String statusLabel(String s) => s
      .replaceAll('_', ' ')
      .replaceFirstMapped(RegExp(r'^\w'), (m) => m.group(0)!.toUpperCase());

  static const List<String> roles = ['builder', 'mazdoor', 'admin'];
  static const List<String> cities = [
    'Gujrat',
    'Lahore',
    'Karachi',
    'Islamabad',
    'Rawalpindi',
    'Faisalabad',
    'Multan',
    'Sialkot',
    'Gujranwala',
    'Other',
  ];
}
