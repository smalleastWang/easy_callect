import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final List<String> files = ['2023新版宣传册2.0【网页版】.pdf', '易采天成VI-LOGO标准化.pdf'];
  final List<String> _downloadedFiles = [];

  Future<void> _copyFileFromAssets(String fileName) async {
    try {
      // 加载asset中的文件
      final ByteData data = await rootBundle.load('assets/pdf/$fileName');
      final String documentsDirectory = (await getApplicationDocumentsDirectory()).path;
      final String filePath = '$documentsDirectory/$fileName';
      final File file = File(filePath);
      await file.writeAsBytes(data.buffer.asUint8List(), flush: true);

      // 打开文件
      OpenFile.open(filePath);

      // 更新UI
      setState(() {
        _downloadedFiles.add(fileName);
      });

      // 显示SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('文件已保存到本地'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      // 错误处理
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('保存文件时出错: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('资料下载'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // 刷新功能
              setState(() {
                _downloadedFiles.clear();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: files.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(
                  _downloadedFiles.contains(files[index]) ? Icons.check_circle : Icons.download,
                  color: _downloadedFiles.contains(files[index]) ? Colors.green : Colors.blue,
                ),
                title: Text(files[index]),
                subtitle: _downloadedFiles.contains(files[index]) ? const Text('已下载') : null,
                trailing: IconButton(
                  icon: const Icon(Icons.file_download),
                  onPressed: () => _copyFileFromAssets(files[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}