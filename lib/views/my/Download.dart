import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:easy_collect/utils/icons.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final List<String> files = [
    '2023新版宣传册2.0【网页版】.pdf',
    '易采天成VI-LOGO标准化.pdf',
    '文件3.pdf',
    '文件4.pdf',
    '文件5.pdf',
    '文件6.pdf',
    '文件7.pdf'
  ];

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: const Color(0xFFF1F5F9),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  DownloadItem(
                    fileName: files[index],
                    isDownloaded: _downloadedFiles.contains(files[index]),
                    onDownload: () => _copyFileFromAssets(files[index]),
                  ),
                  if (index < files.length - 1)
                    Container(
                      height: 0.5,
                      color: const Color(0xFFE9E8E8),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class DownloadItem extends StatefulWidget {
  final String fileName;
  final bool isDownloaded;
  final VoidCallback onDownload;

  const DownloadItem({
    super.key,
    required this.fileName,
    required this.isDownloaded,
    required this.onDownload,
  });

  @override
  _DownloadItemState createState() => _DownloadItemState();
}

class _DownloadItemState extends State<DownloadItem> {
  bool isDownloading = false;
  double downloadProgress = 0.0;
  double fileSizeMB = 10.0; // 假设文件大小为10MB

  void startDownload() async {
    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });

    // 模拟下载过程
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          downloadProgress = i / 10;
        });
      });
    }

    setState(() {
      isDownloading = false;
      downloadProgress = 1.0;
    });

    widget.onDownload();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: ListTile(
        leading: const Icon(MyIcons.pdf, color: Color(0xFFFB4337)), 
        title: Text(widget.fileName),
        subtitle: Row(
          children: [
            Text('${fileSizeMB.toStringAsFixed(1)}MB'),
            const SizedBox(width: 4),
            if (isDownloading)
              Expanded(
                child: LinearProgressIndicator(
                  value: downloadProgress,
                  minHeight: 6, // 设置进度条高度为6像素
                ),
              ),
          ],
        ),
        trailing: isDownloading
            ? SizedBox(
                child: Text(
                  '下载中',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF297DFF), fontSize: 16),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: GestureDetector(
                  onTap: startDownload,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20),
                    //   color: const Color(0xFF297DFF),
                    // ),
                    child: const Text(
                      '下载',
                      style: TextStyle(color: Color(0xFF297DFF), fontSize: 14),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
