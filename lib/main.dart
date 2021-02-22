import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:webblen_web_app/ui/bottom_sheets/setup_bottom_sheet_ui.dart';

import 'app/locator.dart';
import 'app/router.gr.dart';
import 'app/theme_config.dart';

void main() async {
  // Register all the models and services before the app starts
  await ThemeManager.initialise();
  WidgetsFlutterBinding.ensureInitialized();
  // await fb.initializeApp(
  //   apiKey: "AIzaSyApD1l8k7XAUQ7jOMA0p9edI6JllSbCawM",
  //   authDomain: "webblen-events.firebaseapp.com",
  //   databaseURL: "https://webblen-events.firebaseio.com",
  //   projectId: "webblen-events",
  //   storageBucket: "webblen-events.appspot.com",
  //   messagingSenderId: "618036466482",
  // );
  setupLocator();
  setupBottomSheetUI();
  setupSnackBarUi();

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
        initialRoute: Routes.RootViewRoute,
        onGenerateRoute: WebblenRouter().onGenerateRoute,
        navigatorKey: StackedService.navigatorKey,
      ),
    );
  }
}
