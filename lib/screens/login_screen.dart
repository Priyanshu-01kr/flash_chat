import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/input_text_field.dart';
import '../components/reusable_card.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool _saving = false; //showing the spinner

  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Flexible(
                    child: Hero(
                      tag: 'logo',
                      child: Image(
                        image: AssetImage('images/logo.png'),
                        height: 200,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 48),
                InputTextField(
                  hintText: 'Enter your email',
                  onChanged: (value) {
                    email = value;
                  },
                  obscureText: false,
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(height: 8.0),
                InputTextField(
                  hintText: 'Enter password',
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  textInputType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 24.0),
                ReusableCard(
                  cardText: 'Log In',
                  cardColor: Colors.lightBlueAccent,
                  onPressed: () async {
                    // understand this _saving
                    setState(() {
                      _saving = true;
                    });
                    try {
                      final userCredential = await _auth
                          .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                      print(userCredential);
                      Navigator.pushNamed(context, ChatScreen.id);
                      setState(() {
                        _saving = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
