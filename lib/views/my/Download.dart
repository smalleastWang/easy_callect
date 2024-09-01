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
  bool isPreviewing = false;

  @override
  void initState() {
    super.initState();
    state = widget.state;
    fileType = state.extra as String?;
    _fetchFileList();
  }

  Future<File> createFileOfPdfUrl(String url) async {
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$filename");

    // 检查文件是否已经存在
    if (await file.exists()) {
      return file;
    }

    // 如果文件不存在，则从网络下载
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error downloading or saving file!');
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
          // 开始预加载文件
          _preloadFiles(data);
        }
      } else {
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
    setState(() {
      isPreviewing = true;
    });

    try {
      final file = await createFileOfPdfUrl(filePath);
      if (file.existsSync()) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfPreviewPage(path: file.path),
          ),
        ).then((_) {
          setState(() {
            isPreviewing = false;
          });
        });
      } else {
        throw Exception('File not found');
      }
    } catch (e) {
      setState(() {
        isPreviewing = false;
      });
      print('Preview error: $e');
    }
  }

  void _preloadFiles(List<dynamic> files) {
    for (var file in files) {
      createFileOfPdfUrl(file['filePath']).then((_) {
        print('Preloaded ${file["fileName"]}');
      }).catchError((e) {
        print('Error preloading file: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: fileType == 'help' ? const Text('帮助手册') : const Text('资料下载'),
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
              isPreviewing: isPreviewing,
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
  final bool isPreviewing;
  final VoidCallback onDownload;
  final VoidCallback? onPreview;

  const DownloadItem({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.filePath,
    required this.isDownloaded,
    required this.isPreviewing,
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
            if (isDownloadComplete)
              const Text('下载完成', style: TextStyle(color: Colors.green, fontSize: 13)),
          ],
        ),
        trailing: widget.isPreviewing
            ? const CircularProgressIndicator()
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.onPreview != null)
                    GestureDetector(
                      onTap: widget.onPreview,
                      child: const Text(
                        '预览',
                        style: TextStyle(color: Color(0xFF0EA4FF), fontSize: 14),
                      ),
                    ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: isDownloading || widget.isDownloaded ? null : startDownload,
                    child: Text(
                      isDownloadComplete || widget.isDownloaded ? '已下载' : '下载',
                      style: TextStyle(
                        color: isDownloading || widget.isDownloaded
                            ? const Color(0xFF999999)
                            : const Color(0xFF0EA4FF),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}