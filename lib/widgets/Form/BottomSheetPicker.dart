import 'package:flutter/material.dart';

class BottomSheetPickerWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onSelect;
  final List<Map<String, dynamic>> options;
  final String? hintText;

  const BottomSheetPickerWidget({
    super.key,
    required this.onSelect,
    required this.options,
    this.hintText,
  });

  @override
  State<BottomSheetPickerWidget> createState() => _BottomSheetPickerWidgetState();
}

class _BottomSheetPickerWidgetState extends State<BottomSheetPickerWidget> {
  final TextEditingController _controller = TextEditingController();

  _handlePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final key = option.keys.first;
              final value = option[key];

              return Column(
                children: [
                  ListTile(
                    title: Text(
                      value,
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      _controller.text = value;
                      widget.onSelect(option);
                      Navigator.pop(context);
                    },
                  ),
                  if (index < widget.options.length - 1)
                    Divider(height: 1, color: Colors.grey[300]), // Add divider between items
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: _controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: widget.hintText ?? '请选择一个选项',
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      onTap: () => _handlePicker(context),
    );
  }
}