import 'package:flash_chat/components/constants.dart';
import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final String hintText;
  final void Function(String) onChanged;
  final bool obscureText;
  final TextInputType textInputType;
  const InputTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.obscureText,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
        child: TextField(
          textAlign: TextAlign.center,
          keyboardType: textInputType,
          obscureText: obscureText,
          decoration: kTextFieldDecoration.copyWith(hintText: hintText),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
