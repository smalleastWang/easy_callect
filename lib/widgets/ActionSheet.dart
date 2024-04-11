import 'package:flutter/material.dart';

typedef OnTap = void Function();

class ActionSheetItemWidget extends StatelessWidget {
  final String text;
  final OnTap? onTap;
  const ActionSheetItemWidget({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior:  HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(text),
      ),
    );
  }
}