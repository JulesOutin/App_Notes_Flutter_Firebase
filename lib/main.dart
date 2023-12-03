import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'signup_screen.dart';
import 'login_screen.dart';
import 'welcome.dart';
import 'note_user_screen.dart';
// 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/' : (context) => const Welcome(),
        '/signup' : (context) => const SignUpScreen(),
        '/login' : (context) => const LoginScreen(),
        '/notes' : (context) => const NoteScreen(),
      },
    );
  }
}