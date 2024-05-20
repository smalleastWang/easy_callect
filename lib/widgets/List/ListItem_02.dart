import 'package:flutter/material.dart';

typedef Render = Widget Function(dynamic value, Map<String, dynamic> record, ListColumnModal column);

class ListColumnModal {
  String field;
  String label;
  Render? render;
  ListColumnModal({required this.field, required this.label, this.render});
}

class ListItemWidget extends StatelessWidget {
  final List<ListColumnModal> columns;
  final Map<String, dynamic> rowData;

  const ListItemWidget({super.key, required this.columns, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(columns: columns, rowData: rowData),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final column in columns)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      column.label,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: column.render != null
                            ? column.render!(rowData[column.field], rowData, column)
                            : Text(
                                '${rowData[column.field] ?? "-"}',
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final List<ListColumnModal> columns;
  final Map<String, dynamic> rowData;

  const DetailPage({super.key, required this.columns, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('详细信息'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final column in columns)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      column.label,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: column.render != null
                            ? column.render!(rowData[column.field], rowData, column)
                            : Text(
                                '${rowData[column.field] ?? "-"}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}