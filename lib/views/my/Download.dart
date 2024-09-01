import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_collect/views/my/PdfPreviePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_collect/api/common.dart';

// 资料下载页面
class DownloadPage extends ConsumerStatefulWidget {
  final GoRouterState state;
  const DownloadPage({super.key, required this.state});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DownloadPageState();
}

class _DownloadPageState extends ConsumerState<DownloadPage> {
  late GoRouterState state;
  String? fileType;

  AsyncValue<List<dynamic>> fileList = const AsyncValue.loading();
  final Set<String> _downloadedFiles = {};

  @override
  void initState() {
    super.initState();
    state = widget.state;
    fileType = state.extra as String?;
    _fetchFileList();
  }

  Future<File> createFileOfPdfUrl(url) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  void _fetchFileList() {
    final provider = fileListProvider({"code": fileType});
    ref.read(provider.future).then((data) {
      if (data.isNotEmpty) {
        data[0]['filePath'] = 'http://icon.artdong.online/%E3%80%90%E6%9C%A8%E5%AD%90%E6%95%99%E8%82%B2%E5%85%B1%E4%BA%AB%E3%80%91%E5%A6%82%E4%BD%95%E8%AF%B4%EF%BC%8C%E9%9D%92%E6%98%A5%E6%9C%9F%E7%94%B7%E5%AD%A9%E6%89%8D%E4%BC%9A%E5%90%AC.pdf';
        if (mounted) {
          setState(() {
            fileList = AsyncValue.data(data);
          });
        }
      } else {
        // 可以在这里处理 data 为空的情况
        print('No files found.');
      }
    }).catchError((error) {
      print('Error fetching file list: $error');
    });
  }

  void _onFileDownloaded(String fileName) {
    setState(() {
      _downloadedFiles.add(fileName);
    });
  }

  // 打开 PDF 预览页面
  void _onFilePreview(String filePath) async {
   createFileOfPdfUrl(filePath).then((f) {
      String remotePDFpath = f.path;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfPreviewPage(path: remotePDFpath),
        ),
      );
    });
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
          child: Column(
            children: [
              Expanded(
                child: fileList.when(
                  data: (data) => _buildFileList(context, data),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileList(BuildContext context, List<dynamic> files) {
    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return Column(
          children: [
            DownloadItem(
              fileName: file["fileName"],
              fileSize: file["fileSize"],
              filePath: file["filePath"],
              isDownloaded: _downloadedFiles.contains(file["fileName"]),
              onDownload: () => _onFileDownloaded(file["fileName"]),
              onPreview: fileType == 'help' ? () => _onFilePreview(file["filePath"]) : null,
            ),
            const Divider(
              color: Color(0xFFE9E8E8),
              height: 0.5,
              indent: 12,
              endIndent: 12,
            ),
          ],
        );
      },
    );
  }
}

// 文件下载项组件
class DownloadItem extends StatefulWidget {
  final String fileName;
  final String fileSize;
  final String filePath;
  final bool isDownloaded;
  final VoidCallback onDownload;
  final VoidCallback? onPreview;

  const DownloadItem({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.filePath,
    required this.isDownloaded,
    required this.onDownload,
    this.onPreview,
  });

  @override
  State<DownloadItem> createState() => _DownloadItemState();
}

class _DownloadItemState extends State<DownloadItem> {
  bool isDownloading = false;
  double downloadProgress = 0.0;
  bool isDownloadComplete = false; // 添加状态变量

  Future<void> startDownload() async {
    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });

    try {
      final dio = Dio();
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/${widget.fileName}';

      await dio.download(
        widget.filePath,
        savePath,
        onReceiveProgress: (received, total) {
          setState(() {
            downloadProgress = received / total;
          });
        },
      );

      setState(() {
        isDownloading = false;
        downloadProgress = 1.0;
        isDownloadComplete = true; // 下载完成，更新状态变量
      });

      widget.onDownload();
    } catch (e) {
      print('Download error: $e');
      setState(() {
        isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: SvgPicture.asset('assets/icon/svg/optimized/pdf.svg', fit: BoxFit.fill),
        title: Text(widget.fileName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        subtitle: Row(
          children: [
            Text(widget.fileSize, style: const TextStyle(color: Color(0xFF999999), fontSize: 13)),
            const SizedBox(width: 4),
            if (isDownloading)
              Expanded(
                child: LinearProgressIndicator(
                  value: downloadProgress,
                  minHeight: 6,
                ),
              ),
          ],
        ),
        trailing: isDownloading
            ? const Text(
                '下载中',
                style: TextStyle(color: Color(0xFF297DFF), fontSize: 14, fontWeight: FontWeight.bold),
              )
            : isDownloadComplete
                ? const Text(
                    '下载完成', // 下载完成后显示“下载完成”
                    style: TextStyle(color: Color(0xFF297DFF), fontSize: 14, fontWeight: FontWeight.bold),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.onPreview != null)
                        GestureDetector(
                          onTap: widget.onPreview,
                          child: const Text(
                            '预览',
                            style: TextStyle(color: Color(0xFF297DFF), fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: startDownload,
                        child: const Text(
                          '下载',
                          style: TextStyle(color: Color(0xFF297DFF), fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}