import 'package:flutter/material.dart';

typedef Pressed = void Function();

class BlockButton extends StatelessWidget {
  final Pressed? onPressed;
  final String text;
  const BlockButton({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).primaryColor.withOpacity(0.3)
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(text, style: const TextStyle(fontSize: 18, color: Colors.white)),
            ),
            
          ),
        ),
      ],
    );
  }
}