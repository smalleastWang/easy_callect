import 'package:flutter/material.dart';

class ListCardTitle extends StatelessWidget {
  final Function()? onTap;
  final Widget title;
  final bool hasDetail;
  const ListCardTitle({super.key, this.onTap, required this.title, this.hasDetail = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          title,
          if (hasDetail) 
            const Icon(Icons.arrow_forward_ios, color: Color(0xff888888), size: 16),        
        ],
      ),
    );
  }
}

class ListCardCell extends StatelessWidget {
  final String label;
  final String? value;
  final double? labelWidth;
  const ListCardCell({super.key, required this.label, this.value, this.labelWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth ?? 100,
            child: Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
          ),
          Text(value ?? '-', style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
        ],
      ),
    );
  }
}

class ListCardCellTime extends StatelessWidget {
  final String label;
  final String? value;
  const ListCardCellTime({super.key, required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Row(
          children: [
            Text('$label：', style: const TextStyle(color: Color(0xFF999999))),
            Text(value ?? '-', style: const TextStyle(color: Color(0xFF999999))),
          ],
        ),
      ],
    );
  }
}