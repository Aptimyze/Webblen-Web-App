import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'locater.dart';
import 'routing/route_names.dart';
import 'routing/router.dart';
import 'services/navigation/navigation_service.dart';
import 'widgets/layout/layout_template.dart';

void main() {
  setupLocater();
  fb.initializeApp(
    apiKey: "AIzaSyApD1l8k7XAUQ7jOMA0p9edI6JllSbCawM",
    authDomain: "webblen-events.firebaseapp.com",
    databaseURL: "https://webblen-events.firebaseio.com",
    projectId: "webblen-events",
    storageBucket: "webblen-events.appspot.com",
    messagingSenderId: "618036466482",
  );
  runApp(WebblenWebApp());
}

class WebblenWebApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [StreamProvider<FirebaseUser>.value(value: FirebaseAuth.instance.onAuthStateChanged)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Webblen',
        theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: "Helvetica Neue",
              ),
        ),
        builder: (context, child) => LayoutTemplate(
          child: child,
        ),
        navigatorKey: locator<NavigationService>().navigatorKey,
        onGenerateRoute: generateRoute,
        initialRoute: HomeRoute,
      ),
    );
  }
}
