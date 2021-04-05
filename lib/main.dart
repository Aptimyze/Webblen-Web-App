import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/ui/bottom_sheets/setup_bottom_sheet_ui.dart';

import 'app/router.gr.dart';
import 'app/theme_config.dart';

void main() async {
  // Register all the models and services before the app starts
  await ThemeManager.initialise();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  setupBottomSheetUI();
  setupSnackBarUi();
  setPathUrlStrategy();
  runApp(WebblenWebApp());
}

void setupSnackBarUi() {
  final service = locator<SnackbarService>();
  service.registerSnackbarConfig(
    SnackbarConfig(
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      mainButtonTextColor: Colors.black,
    ),
  );
}

class WebblenWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      lightTheme: regularTheme,
      darkTheme: darkTheme,
      builder: (context, regularTheme, darkTheme, themeMode) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Webblen',
        theme: regularTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        initialRoute: Routes.WebblenBaseViewRoute,
        onGenerateRoute: WebblenRouter().onGenerateRoute,
        navigatorKey: StackedService.navigatorKey,
      ),
    );
  }
}
