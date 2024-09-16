
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/views/precisionBreeding/widgets/PastureVideo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

///
/// 实时视频
class FinanceVideoPage extends ConsumerStatefulWidget {
  const FinanceVideoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FinanceVideoPageState();
}

class _FinanceVideoPageState extends ConsumerState<FinanceVideoPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(RouteEnum.financeVideo.title)),
      body: const PastureVideo()
    );
  }
}