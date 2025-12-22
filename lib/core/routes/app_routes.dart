import 'package:flutter/material.dart';
import 'package:defindia3/features/credentials/presentation/screens/dashboard_screen.dart';
import 'package:defindia3/features/credentials/presentation/screens/add_edit_credential_screen.dart';
import 'package:defindia3/features/webview_login/presentation/screens/webview_login_screen.dart';

/// Saare route names ek jagah.
class AppRoutes {
  AppRoutes._();

  static const String dashboard = '/';
  static const String addEditCredential = '/add-edit-credential';
  static const String webviewLogin = '/webview-login';
}

/// Global navigation helper.
class AppNavigator {
  AppNavigator._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<T?> pushNamed<T extends Object?>(String routeName,
      {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      String routeName,
      {TO? result,
        Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>([T? result]) {
    navigatorKey.currentState!.pop<T>(result);
  }
}

/// Centralized route handling.
/// Is function ko MaterialApp.onGenerateRoute me use karo.
Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;

  switch (settings.name) {
    case AppRoutes.dashboard:
      return MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      );

    case AppRoutes.addEditCredential:
    // args null ho sakta hai (add) ya CredentialEntity (edit)
      return MaterialPageRoute(
        builder: (_) => AddEditCredentialScreen(
          existing: args as dynamic,
        ),
      );

    case AppRoutes.webviewLogin:
      final webArgs = args as WebviewLoginArgs;
      return MaterialPageRoute(
        builder: (_) => WebviewLoginScreen(args: webArgs),
      );

    default:
      return _errorRoute(settings.name);
  }
}

/// Unknown route ke liye simple error screen.
Route<dynamic> _errorRoute(String? name) {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(
        title: const Text('Route error'),
      ),
      body: Center(
        child: Text('No route defined for "$name"'),
      ),
    ),
  );
}
