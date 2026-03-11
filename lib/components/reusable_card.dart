import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ReusableCard extends StatelessWidget {
  final String cardText;
  final Color cardColor;
  final VoidCallback onPressed;
  const ReusableCard({
    super.key,
    required this.cardText,
    required this.cardColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        elevation: 8.0,
        color: cardColor,
        margin: EdgeInsets.all(12.0),
        shadowColor: CupertinoColors.systemGrey,
        child: MaterialButton(
          minWidth: 200,
          height: 42,
          onPressed: onPressed,
          // onPressed: () {
          //   onPressed;
          // },
          child: Center(
            child: Text(
              cardText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
