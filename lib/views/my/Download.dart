import 'package:dio/dio.dart';
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
  
  // 保存文件列表数据
  AsyncValue<List<dynamic>> fileList = const AsyncValue.loading();
  // 保存已下载的文件名
  final Set<String> _downloadedFiles = {};

  @override
  void initState() {
    super.initState();
    state = widget.state;
    fileType = state.extra as String?;
    _fetchFileList();
  }

  // 获取文件列表
  void _fetchFileList() {
    final provider = fileListProvider({"code": fileType});
    ref.read(provider.future).then((data) {
      setState(() {
        fileList = AsyncValue.data(data);
      });
    }).catchError((error) {
      print('Error fetching file list: $error');
    });
  }

  // 更新已下载文件的状态
  void _onFileDownloaded(String fileName) {
    setState(() {
      _downloadedFiles.add(fileName);
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

  // 构建文件列表
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
            ),
            // if (index < files.length - 1)
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

  const DownloadItem({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.filePath,
    required this.isDownloaded,
    required this.onDownload,
  });

  @override
  State<DownloadItem> createState() => _DownloadItemState();
}

class _DownloadItemState extends State<DownloadItem> {
  bool isDownloading = false;
  double downloadProgress = 0.0;

  // 开始下载文件
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
            : GestureDetector(
                onTap: startDownload,
                child: const Text(
                  '下载',
                  style: TextStyle(color: Color(0xFF297DFF), fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}