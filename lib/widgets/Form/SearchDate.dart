import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';

class SearchDateWidget extends StatefulWidget {
  final Function onChange;
  final String? hintText;
  const SearchDateWidget({super.key, required this.onChange, this.hintText});

  @override
  State<SearchDateWidget> createState() => _SearchDateWidgetState();
}

class _SearchDateWidgetState extends State<SearchDateWidget> {

  String firstDate = '';
  String lastDate = '';

  final TextEditingController _controller = TextEditingController();

  _handleDate(BuildContext context) {
    Picker ps = Picker(
      hideHeader: true,
      adapter: DateTimePickerAdapter(type: PickerDateTimeType.kYMD, isNumberMonth: true),
      onConfirm: (Picker picker, List value) {
        DateTime? date = (picker.adapter as DateTimePickerAdapter).value;
        if (date == null) return;
        setState(() {
          firstDate = '${date.year}-${date.month}-${date.day} 00:00';
        });
      }
    );

    Picker pe = Picker(
      hideHeader: true,
      adapter: DateTimePickerAdapter(type: PickerDateTimeType.kYMD, isNumberMonth: true),
      onConfirm: (Picker picker, List value) {
        DateTime? date = (picker.adapter as DateTimePickerAdapter).value;
        if (date == null) return;
        setState(() {
          lastDate = '${date.year}-${date.month}-${date.day} 23:59';
        });
      }
    );

    List<Widget> actions = [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('取消')
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          ps.onConfirm?.call(ps, ps.selecteds);
          pe.onConfirm?.call(pe, pe.selecteds);
          _controller.text = '$firstDate-$lastDate';
          widget.onChange(firstDate, lastDate);
        },
        child: const Text('确定')
      )
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("选择时间"),
          actions: actions,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("开始时间:"),
              ps.makePicker(),
              const Text("结束时间:"),
              pe.makePicker()
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: _controller,
      decoration:  InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
        border: const OutlineInputBorder(),
        hintText: widget.hintText ?? '请选择时间',
      ),
      onTap: () => _handleDate(context),
    );
  }
}