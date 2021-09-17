import 'package:chat/screens/friends_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        ChatScreen.id: (context) => const ChatScreen(),
        FriendsScreen.id: (context) => const FriendsScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
      },
      initialRoute: WelcomeScreen.id,
    );
  }
}
