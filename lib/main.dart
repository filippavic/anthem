import 'package:anthem/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Anthem',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        fontFamily: "Inter",
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
          ),
          selectedItemColor: Constants.kSecondaryColor,
          unselectedItemColor: Colors.white38,
        ),
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

