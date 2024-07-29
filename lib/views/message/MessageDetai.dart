import 'package:flutter/material.dart';


class MessageDetailPage extends StatelessWidget {
  final String subject;
  final String content;
  final String createTime;
  const MessageDetailPage({super.key, required this.subject, required this.content, required this.createTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息详情'),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 16),
            child: Text(subject),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Text(content, style: const TextStyle(fontSize: 14)),
            )
          ),
        ],
      ),
    );
  }
}

