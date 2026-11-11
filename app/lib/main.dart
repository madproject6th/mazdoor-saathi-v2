import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/services/api_client.dart';
import 'core/services/notification_service.dart';
import 'providers/app_state.dart';
import 'repositories/app_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase is best-effort: without config (demo / web preview) the app
  // still runs in demo mode.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init skipped: $e');
  }
  try {
    await NotificationService().initialize();
  } catch (_) {}

  final api = ApiClient();
  final state = AppState(api: api);
  await state.initPrefs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(value: state),
        Provider<AppRepository>.value(value: AppRepository(api)),
        Provider<ApiClient>.value(value: api),
      ],
      child: const MazdoorSathiApp(),
    ),
  );
}
