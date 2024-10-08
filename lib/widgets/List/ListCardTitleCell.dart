import 'package:easy_collect/utils/dialog.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:flutter/material.dart';

class ListCardTitleStateModal {
  final Color bgColor;
  final Color textColor;
  final String text;
  ListCardTitleStateModal({this.bgColor = const Color(0xFFCCD2E1), this.textColor = Colors.white, required this.text});
}

class ListCardTitleCell extends StatelessWidget {
  final List<ListColumnModal>? detailColumns;
  final double detailLabelWidth;
  final String? title;
  final Widget? titleWidget;
  final Map<String, dynamic> rowData;
  final ListCardTitleStateModal? state;
  const ListCardTitleCell({super.key, this.detailColumns, required this.rowData, this.title, this.titleWidget, this.state, this.detailLabelWidth = 100});


  Widget get _renderTitle {
    Widget titleText = Text(title ?? '-', style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500));
    if (titleWidget != null) {
      return titleWidget!;
    } else if (state != null) {
      return Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            decoration: BoxDecoration(
              color: state!.bgColor,
              borderRadius: BorderRadius.circular(3)
            ),
            child: Text(state!.text, style: TextStyle(color: state!.textColor)),
          ),
          titleText,
        ],
      );
    }
    return titleText;

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: detailColumns == null ? null : () {
        showMyModalBottomSheet(
          context: context,
          title: '详情信息',
          contentBuilder: (BuildContext context) {
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: detailColumns!.map((e) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: e.labelWidth ?? detailLabelWidth,
                          child: Text(e.label, style: const TextStyle(color: Color(0xFF666666))),
                        ),
                        Expanded(
                          child: e.render == null ? Text(rowData[e.field] ?? '-') : e.render!(rowData[e.field], rowData, e)
                        )
                        
                      ],
                    ),
                  )).toList()
                ),
              )
            );
          }
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _renderTitle,
            detailColumns != null ? const Icon(Icons.arrow_forward_ios, color: Color(0xff888888), size: 16) : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}