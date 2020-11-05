import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/models/auth_service.dart';
import 'package:restaurant_ui_kit/providers/app_provider.dart';

import 'package:restaurant_ui_kit/screens/splash.dart';
import 'package:restaurant_ui_kit/util/const.dart';

import 'util/const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
 final AppProvider appProvider = AppProvider();
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance),
          ),
          
          StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
          ),
          ChangeNotifierProvider(create: (_) => AppProvider()),
        ],
        child: MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          theme: appProvider.theme,
          darkTheme: Constants.darkTheme,
          home: SplashScreen(),
        ));
  }
}
