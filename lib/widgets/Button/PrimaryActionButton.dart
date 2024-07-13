import 'package:flutter/material.dart';

class PrimaryActionButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  const PrimaryActionButton({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed, 
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0), // 设置圆角半径为6.0
          ),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 13)), 
      ),
    );
  }
}


class OutlineActionButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  const OutlineActionButton({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        // maximumSize: const Size.fromHeight(32),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        side: const BorderSide(color: Color(0xFFCBCBCB)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0), // 设置圆角半径为6.0
        ),
      ),
      child: Text(text, style: const TextStyle(color: Color(0xFF444444), fontSize: 13)), 
    )
    ) ;
  }
}

class MoreActionWidget extends StatefulWidget {
  final String? text;
  final Function(Object?)? onSelected;
  final List<PopupMenuItem> items;
  const MoreActionWidget({super.key, this.text, this.items =  const [], this.onSelected});

  @override
  State<MoreActionWidget> createState() => _MoreActionWidgetState();
}

class _MoreActionWidgetState extends State<MoreActionWidget> {

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: widget.onSelected,
      // color: Colors.red,
      surfaceTintColor: Colors.white,
      itemBuilder: (context) => widget.items,
      offset: const Offset(0, 25),
      child: Text(widget.text ?? '更多'),
    );
  }
}