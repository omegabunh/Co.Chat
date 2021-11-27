import 'package:flutter/material.dart';

//Packages
import 'package:firebase_analytics/firebase_analytics.dart';

//Services
import './services/navigation_services.dart';

//Pages
import './pages/splash_page.dart';

void main() {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(
          MainApp(),
        );
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CompanyChat',
      theme: ThemeData(
        backgroundColor: Color.fromRGBO(155, 217, 191, 1.0),
        scaffoldBackgroundColor: Color.fromRGBO(155, 217, 191, 1.0),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(79, 109, 98, 1.0),
        ),
      ),
      //navigatorKey: NavigationService.navigatorKey,
    );
  }
}
