import 'dart:async';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:easy_collect/views/my/PdfPreviePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_collect/api/common.dart';
import 'package:android_intent_plus/android_intent.dart';

void refreshMediaScanner(String filePath) {
  if (Platform.isAndroid) {
    // 仅在 Android 上执行
    final intent = AndroidIntent(
      action: 'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
      data: Uri.file(filePath).toString(),
    );
    intent.launch();
  } else if (Platform.isIOS) {
    // iOS 不需要手动刷新媒体库，系统会自动处理
    print('No need to refresh media scanner on iOS');
  }
}

// 申请权限
Future<bool> checkStoragePermission() async {
  // 先对所在平台进行判断
  bool isDenied = await Permission.storage.isDenied;
  if (isDenied) {
    PermissionStatus status = await Permission.storage.request();
    if (status.isDenied) return false;
  }
  return true;
}

Future<String> getDocumentPath(String fileName) async {
  Directory? directory;

  if (Platform.isAndroid) {
    // directory = await getExternalStorageDirectory();
    // 保存到 Android 的下载文件夹
    directory = Directory('/storage/emulated/0/Download');
    // if (directory != null) {
    //   // 保存到 Android 的文档文件夹
    //   directory = Directory('${directory.path}/Documents');
    // }
  } else if (Platform.isIOS) {
    directory = await getDownloadsDirectory();
  }

  // 如果目录不存在，创建它
  if (directory != null && !(await directory.exists())) {
    await directory.create(recursive: true);
  }

  // 返回完整的文件路径
  return '${directory?.path}/$fileName';
}

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
  static const Set<String> supportedFormats = {'pdf'};
  bool isPreviewing = false;

  @override
  void initState() {
    super.initState();
    state = widget.state;
    fileType = state.extra as String?;
    _fetchFileList();
  }

  Future<File> createTempFileOfPdfUrl(String url) async {
    final directory = await getTemporaryDirectory();
    final filename = url.substring(url.lastIndexOf("/") + 1);
    final filePath = '${directory.path}/$filename';
    File file = File(filePath);

    // 如果文件不存在，则从网络下载
    if (!(await file.exists())) {
      try {
        var request = await HttpClient().getUrl(Uri.parse(url));
        var response = await request.close();
        var bytes = await consolidateHttpClientResponseBytes(response);
        await file.writeAsBytes(bytes, flush: true);
      } catch (e) {
        throw Exception('Error downloading or saving file!');
      }
    }

    return file;
  }

  void _fetchFileList() {
    final provider = fileListProvider({"code": fileType});
    ref.read(provider.future).then((data) {
      if (data.isNotEmpty) {
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

  // 显示文件格式不支持的提示
  void _showUnsupportedFormatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white, // Ensure AlertDialog background is white
          // contentPadding: const EdgeInsets.all(0),
          title: const Text('格式不支持'),
          content: const Text('此文件格式不支持预览。'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('确定', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  // 打开 PDF 预览页面
  void _onFilePreview(String filePath) async {
    final fileExtension = filePath.split('.').last.toLowerCase();

    if (!supportedFormats.contains(fileExtension)) {
      _showUnsupportedFormatDialog();
      return;
    }

    setState(() {
      isPreviewing = true;
    });

    File? tempFile;
    try {
      tempFile = await createTempFileOfPdfUrl(filePath);
      if (tempFile.existsSync()) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfPreviewPage(path: tempFile!.path),
          ),
        );
      } else {
        throw Exception('File not found');
      }
    } catch (e) {
      print('Preview error: $e');
    } finally {
      // 删除临时文件
      setState(() {
        isPreviewing = false;
      });
      if (tempFile != null && await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  void _preloadFiles(List<dynamic> files) {
    for (var file in files) {
      createTempFileOfPdfUrl(file['filePath']).then((_) {
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
    bool isPermission = await checkStoragePermission();
    if (!isPermission) {
      EasyLoading.showToast('请授权手机存储权限');
      return;
    }

    final savePath = await getDocumentPath(widget.fileName);

    // 检查文件是否已存在并删除
    final file = File(savePath);
    if (await file.exists()) {
      await file.delete();  // 删除已存在的文件
    }

    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });

    try {
      final dio = Dio();

      await dio.download(
        widget.filePath,
        savePath,
        onReceiveProgress: (received, total) {
          setState(() {
            downloadProgress = received / total;
          });
        },
      );
      refreshMediaScanner(savePath);
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
                        color: isDownloading || widget.isDownloaded || isDownloadComplete
                            ? const Color(0xFF999999)
                            : const Color(0xFF297DFF),
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