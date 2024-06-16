import 'package:flutter/material.dart';

class CellWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? assetIcon;
  final GestureTapCallback? onTap;

  const CellWidget({
    super.key, 
    required this.title, 
    this.icon, 
    this.assetIcon, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            if (icon != null) Icon(icon) else if (assetIcon != null) Image.asset(assetIcon!, width: 32, height: 32),
            Text(' $title', style: const TextStyle(fontSize: 16)),
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Icon(Icons.chevron_right)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}