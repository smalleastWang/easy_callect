import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String version = '';

  @override
  void initState() {
    getVersion();
    super.initState();
  }

  getVersion() async {
    // String? solarmonitor = await MyApi.fetchVersionApi();
    // if (solarmonitor != null) {
    //   setState(() {
    //     version = solarmonitor;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: const Text('首页'),
      ),
    );
  }
}