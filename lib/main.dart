import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:defindia3/core/constants/app_strings.dart';
import 'package:defindia3/core/routes/app_routes.dart';
import 'package:defindia3/services/hive_db_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveDbService.init();
  await InAppWebViewController.setWebContentsDebuggingEnabled(true);

  runApp(const DefIndia3App());
}

class DefIndia3App extends StatelessWidget {
  const DefIndia3App({super.key});

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1E88E5),
        secondary: Color(0xFFFFC107),
        background: Color(0xFFF9FAFB),
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      cardColor: Colors.white,
      useMaterial3: false,
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF1E88E5),
        secondary: Color(0xFFFFC107),
        background: Color(0xFF0F172A),
        surface: Color(0xFF111827),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardColor: const Color(0xFF111827),
      useMaterial3: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system, // system ke hisaab se auto switch
      navigatorKey: AppNavigator.navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: AppRoutes.dashboard,
    );
  }
}
