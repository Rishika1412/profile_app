import 'package:flutter/material.dart';
import 'package:profileapp/screens/login_screen.dart';
import 'package:profileapp/screens/profile_screen.dart';
import 'package:profileapp/screens/signup_screen.dart';
import 'package:profileapp/utils/preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().initPrefs();
  runApp(MyApp());
}

final prefs = UserPreferences();

class MyApp extends StatelessWidget {
  final Map<String, dynamic> preferences = {
    'username': prefs.username,
    'password': prefs.password,
    'authFlag': prefs.authFlag
  };
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    String initialRoute = '';
    if (preferences['username'] == '' || preferences['password'] == '') {
      initialRoute = 'signup';
    } else if (preferences['authFlag'] != true) {
      initialRoute = 'login';
    } else {
      initialRoute = 'profile';
    }
    return MaterialApp(
      title: 'Flutter Profile App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        'signup': (context) => const SignUpScreen(),
        'login': (context) => const LoginScreen(),
        'profile': (context) => const ProfileScreen(),
      },
    );
  }
}
