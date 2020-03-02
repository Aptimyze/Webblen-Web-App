import 'package:flutter/material.dart';
import 'package:webblen_web_app/pages/home/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: "Helvetica Neue",
            ),
      ),
      home: HomePage(),
    );
  }
}
