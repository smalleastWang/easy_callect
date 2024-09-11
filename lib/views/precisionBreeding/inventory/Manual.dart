import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/api/inventory.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/Button/BlockButton.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:easy_collect/widgets/List/PickerPastureWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

/// 手工盘点
class ManualPage extends ConsumerStatefulWidget {
  const ManualPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManualPageState();
}

class _ManualPageState extends ConsumerState<ManualPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final PickerEditingController _enclosureController = PickerEditingController();

  bool submitLoading = false;

  @override
  void initState() {
    super.initState();
  }

  _handleSubmit(List<EnclosureModel> options) async {
    if (_enclosureController.value == null) return EasyLoading.showError('请选择圈舍');
    List<String> idList = _enclosureController.value!;
    print("pastureId: ${idList.last}");
    
    try {
      setState(() {
        submitLoading = true;
      });

      String pastureId = idList.last;
      Map<String, dynamic> params = {"buildingIds": [pastureId]};
      await inventoryManual(params);

      context.pop();
    } finally {
      setState(() {
        submitLoading = false;
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> enclosureList = ref.watch(buildingTreeOnlineListProvider);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('手工盘点')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE9E8E8))
                    )
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text('盘点圈舍：', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500)),
                      ),
                      Expanded(
                        child: PickerPastureWidget(
                          selectLast: SelectLast.shed,
                          controller: _enclosureController,
                          options: enclosureList.value ?? [],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                BlockButton(
                  onPressed: submitLoading ? null : () => _handleSubmit(enclosureList.value ?? []),
                  text: '盘点'
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}