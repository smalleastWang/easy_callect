import 'package:easy_collect/models/common/Option.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RegisterTypeWidget<T> extends StatefulWidget {
  final List<OptionModel<T>> options;
  final T? defaultValue;
  final Function(T value) onChange;
  const RegisterTypeWidget({super.key, required this.options, required this.onChange, this.defaultValue});

  @override
  State<RegisterTypeWidget> createState() => _RegisterTypeWidgetState<T>();
}

class _RegisterTypeWidgetState<T> extends State<RegisterTypeWidget> {

  T? _radioValue;


  @override
  void initState() {
    setState(() {
      _radioValue = widget.defaultValue;
    });
    super.initState();
  }
  void _handleTap(T value) {
    setState(() {
      _radioValue = value;
    });
    widget.onChange(value);
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return Wrap(
      alignment: WrapAlignment.start,
      children: widget.options.map((option) {
        return Container(
          alignment: Alignment.centerLeft,
          width: (MediaQuery.of(context).size.width - 30) / (widget.options.length < 3 ? widget.options.length : 3),
          child: Row(
            children: [
              Radio<T>(
                value: option.value,
                groupValue: _radioValue,
                onChanged: (value) => _handleTap(value as T)
              ),
              GestureDetector(
                onTap: () => _handleTap(option.value),
                child: Text(option.label),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}