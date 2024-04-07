import 'package:flutter/material.dart';

typedef Render = Widget Function(dynamic value, Map<String, dynamic> record, ListColumnModal column);

class ListColumnModal {
  String field;
  String label;
  Render? render;
  ListColumnModal({required this.field, required this.label, this.render});
}

class ListItemWidget extends StatefulWidget {
  final List<ListColumnModal> columns;
  final Map<String, dynamic> rowData;

  const ListItemWidget({super.key, required this.columns, required this.rowData});

  @override
  State<ListItemWidget> createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0.0, 1.0), //阴影y轴偏移量
            blurRadius: 5, //阴影模糊程度
            spreadRadius: 2 //阴影扩散程度
          )
        ]
      ),
      child: Wrap(
        spacing: 0,
        runSpacing: 5,
        alignment: WrapAlignment.spaceBetween,
        children: widget.columns.map((e) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 10*2-10*2 -10)/2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(e.label),
                ),
                Expanded(
                  child: e.render == null ? Text(
                    widget.rowData[e.field] ?? '-',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end
                  ) : e.render!(widget.rowData[e.field], widget.rowData, e)
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}