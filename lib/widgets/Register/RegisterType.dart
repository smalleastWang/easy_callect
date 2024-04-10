import 'package:easy_collect/models/common/Option.dart';
import 'package:flutter/material.dart';



class RegisterTypeWidget<T> extends StatefulWidget {
  final List<OptionModel<T>> options;
  const RegisterTypeWidget({super.key, required this.options});

  @override
  State<RegisterTypeWidget> createState() => _RegisterTypeWidgetState<T>();
}

class _RegisterTypeWidgetState<T> extends State<RegisterTypeWidget> {

  T? _radioValue;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.options.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        crossAxisCount: 2,
        childAspectRatio: 1
      ),
      itemBuilder: (context, index) {
        OptionModel<T> option = widget.options[index] as OptionModel<T>;
        return Row(
          children: [
            Radio<T>(
              value: option.value,
              groupValue: _radioValue,
              onChanged: (value) {
                setState(() {
                  _radioValue = value;
                });
              }
            ),
            Text(
              option.label,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        );
      }
    );
  }
}