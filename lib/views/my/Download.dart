import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DownloadPage extends StatefulWidget {
  // ignore: use_super_parameters
  const DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final List<String> files = ['app.pdf', 'website.pdf'];

  Future<void> _copyFileFromAssets(String fileName) async {
    final ByteData data = await rootBundle.load('assets/pdf/$fileName');
    final String documentsDirectory = (await getApplicationDocumentsDirectory()).path;
    final String filePath = '$documentsDirectory/$fileName';
    final File file = File(filePath);
    await file.writeAsBytes(data.buffer.asUint8List(), flush: true);

    // 使用传入的scaffoldContext来显示SnackBar
    ScaffoldMessenger.of(scaffoldContext!).showSnackBar(
      const SnackBar(content: Text('文件已保存到本地')),
    );
  }

  BuildContext? scaffoldContext; // 声明一个BuildContext变量用于保存Scaffold的上下文

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('资料下载'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          // 保存Scaffold的上下文
          scaffoldContext = context;
          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(files[index]),
                onTap: () => _copyFileFromAssets(files[index]),
              );
            },
          );
        },
      ),
    );
  }
}