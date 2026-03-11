import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/input_text_field.dart';
import '../components/reusable_card.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool _saving = false;
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
                  cardText: 'Register',
                  cardColor: Colors.lightBlueAccent,
                  onPressed: () async {
                    setState(() {
                      _saving = true;
                    });
                    try {
                      final newUser = await _auth
                          .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                      if (!mounted) return;
                      Navigator.pushNamed(context, ChatScreen.id);
                      setState(() {
                        _saving = true;
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
