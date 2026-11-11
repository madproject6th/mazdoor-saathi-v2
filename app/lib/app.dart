import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/app_state.dart';
import 'routes/app_routes.dart';

/// Root widget — Material 3, navy/orange theme, EN/UR locales (UR = RTL).
class MazdoorSathiApp extends StatelessWidget {
  const MazdoorSathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return MaterialApp(
      title: 'Mazdoor Sathi',
      debugShowCheckedModeBanner: false,
      locale: Locale(state.locale),
      supportedLocales: const [Locale('en'), Locale('ur')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: state.themeMode,
      initialRoute: '/',
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
