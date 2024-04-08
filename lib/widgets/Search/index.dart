

import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/widgets/DropDownMenu/index.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final List<DropDownMenuModel> filterList;
  const SearchWidget({super.key, required this.filterList});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropDownMenu(filterList: widget.filterList),
      ],
    );
  }
}