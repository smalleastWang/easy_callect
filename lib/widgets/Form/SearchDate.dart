import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';

class SearchDateWidget extends StatefulWidget {
  final Function(String, String) onChange;
  final String? hintText;

  // ignore: use_super_parameters
  const SearchDateWidget({
    Key? key,
    required this.onChange,
    this.hintText,
  }) : super(key: key);

  @override
  State<SearchDateWidget> createState() => _SearchDateWidgetState();
}

class _SearchDateWidgetState extends State<SearchDateWidget> {
  String firstDate = '';
  String lastDate = '';

  final TextEditingController _controller = TextEditingController();

  void _handleDate(BuildContext context) {
    Picker ps = Picker(
      hideHeader: true,
      adapter: DateTimePickerAdapter(type: PickerDateTimeType.kYMD, isNumberMonth: true),
      onConfirm: (Picker picker, List value) {
        DateTime? date = (picker.adapter as DateTimePickerAdapter).value;
        if (date == null) return;
        setState(() {
          firstDate = '${date.year}-${date.month}-${date.day} 00:00';
        });
      },
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
      },
    );

    List<Widget> actions = [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('取消'),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          ps.onConfirm?.call(ps, ps.selecteds);
          pe.onConfirm?.call(pe, pe.selecteds);
          _controller.text = '$firstDate-$lastDate';
          widget.onChange(firstDate, lastDate);
        },
        child: const Text('确定'),
      ),
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
              pe.makePicker(),
            ],
          ),
        );
      },
    );
  }

  void _clearDate() {
    setState(() {
      _controller.clear();
      firstDate = '';
      lastDate = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              TextFormField(
                readOnly: true,
                controller: _controller,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: const OutlineInputBorder(),
                  hintText: widget.hintText ?? '请选择时间',
                ),
                onTap: () => _handleDate(context),
              ),
              if (_controller.text.isNotEmpty)
                IconButton(
                  onPressed: _clearDate,
                  icon: const Icon(Icons.clear),
                  tooltip: '清空',
                ),
            ],
          ),
        ),
      ],
    );
  }
}