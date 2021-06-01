import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/auth/auth_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/ui/bottom_sheets/setup_bottom_sheet_ui.dart';
import 'package:webblen_web_app/ui/custom_dialogs/setup_dialog_ui.dart';

import 'app/theme_config.dart';

void main() async {
  // Register all the models and services before the app starts
  await ThemeManager.initialise();
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  setupDialogUi();
  setupBottomSheetUI();
  setupSnackBarUi();
  setPathUrlStrategy();

  await Future.delayed(Duration(seconds: 2));
  await setupAuthListener();

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

Future<void> setupAuthListener() async {
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  UserDataService _userDataService = locator<UserDataService>();
  AuthService _authService = locator<AuthService>();
  FirebaseAuth.instance.authStateChanges().listen((event) async {
    if (event != null) {
      //print('main dart says logged in');
      _reactiveWebblenUserService.updateUserLoggedIn(!event.isAnonymous);
      if (_reactiveWebblenUserService.userLoggedIn) {
        WebblenUser user = await _userDataService.getWebblenUserByID(event.uid);
        _reactiveWebblenUserService.updateWebblenUser(user);
      }
    } else {
      //print('main dart says not logged in');
      await _authService.signInAnonymously();
    }
  });
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
        onGenerateRoute: StackedRouter().onGenerateRoute,
        navigatorKey: StackedService.navigatorKey,
      ),
    );
  }
}
