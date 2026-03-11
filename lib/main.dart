import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. Import firebase_core
// import 'firebase_options.dart'; // 2. Import the generated options file

import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

// 3. Make the main function async
void main() async {
  // 4. Ensure Flutter widgets are initialized before running Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // 5. Initialize Firebase - THIS IS THE FIX
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 6. Run your app as usual
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
