import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:flutter/material.dart';

//Packages
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';

//Services
import './services/navigation_services.dart';

//Providers
import './providers/authentication_provider.dart';

//Pages
import './pages/splash_page.dart';
import './pages/login_page.dart';
import './pages/register_page.dart';
import './pages/home_page.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext _context) {
            return AuthenticationProvider();
          },
        )
      ],
      child: MaterialApp(
        title: 'CompanyChat',
        theme: ThemeData(
          backgroundColor: Color.fromRGBO(155, 217, 191, 1.0),
          scaffoldBackgroundColor: Color.fromRGBO(155, 217, 191, 1.0),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(79, 109, 98, 1.0),
          ),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext _context) => LoginPage(),
          '/register': (BuildContext _context) => RegisterPage(),
          '/home': (BuildContext _context) => HomePage(),
        },
      ),
    );
  }
}
