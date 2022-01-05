import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:anthem/pages/home_page.dart';
import 'package:anthem/pages/welcome_page.dart';
import 'package:anthem/pages/initial/initial_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anthem',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        fontFamily: "Inter"
      ),
      initialRoute: '/',
      navigatorKey: _navigator,
      routes: <String, WidgetBuilder>{
        '/' : (context) => WelcomePage(),
        '/initial-page' : (context) => InitialPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

