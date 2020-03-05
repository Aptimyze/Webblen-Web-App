import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';
import 'package:webblen_web_app/pages/home/home_page.dart';

void main() {
  fb.initializeApp(
    apiKey: "AIzaSyApD1l8k7XAUQ7jOMA0p9edI6JllSbCawM",
    authDomain: "webblen-events.firebaseapp.com",
    databaseURL: "https://webblen-events.firebaseio.com",
    projectId: "webblen-events",
    storageBucket: "webblen-events.appspot.com",
    messagingSenderId: "618036466482",
  );

  fb.auth().signInAnonymously();
  runApp(WebblenWebApp());
}

class WebblenWebApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: "Helvetica Neue",
            ),
      ),
      home: HomePage(),
    );
  }
}
