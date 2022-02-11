import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import './models/theme.dart';

//Packages
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';

//Services
import 'providers/theme_provider.dart';
import 'services/navigation_service.dart';

//Providers
import './providers/authentication_provider.dart';

//Pages
import './pages/splash_page.dart';
import './pages/login_page.dart';
import './pages/register_page.dart';
import './pages/home_page.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
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
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthenticationProvider>(
              create: (BuildContext _context) {
                return AuthenticationProvider();
              },
            )
          ],
          child: MaterialApp(
            title: 'Co.Chat',
            theme: themeNotifier.isDark ? darkThemeData : lightThemeData,
            navigatorKey: NavigationService.navigatorKey,
            initialRoute: '/login',
            routes: {
              '/login': (BuildContext _context) => LoginPage(),
              '/register': (BuildContext _context) => RegisterPage(),
              '/home': (BuildContext _context) => HomePage(),
            },
            debugShowCheckedModeBanner: false,
          ),
        );
      }),
    );
  }
}
