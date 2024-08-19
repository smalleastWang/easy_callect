import 'dart:async'; // 引入 Timer
import 'package:easy_collect/api/common.dart';
import 'package:easy_collect/models/common/Bank.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BankSelector extends ConsumerStatefulWidget {
  final void Function(Bank? selectedBank) onBankSelected;

  const BankSelector({
    super.key,
    required this.onBankSelected,
  });

  @override
  BankSelectorState createState() => BankSelectorState();
}

class BankSelectorState extends ConsumerState<BankSelector> {
  Bank? selectedBank;
  List<Bank> banks = [];
  List<Bank> filteredBanks = [];
  late TextEditingController _filterController;
  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadBanks();
    _filterController = TextEditingController();
    _scrollController.addListener(() {
      // 取消焦点
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    _debounce?.cancel(); // 取消计时器
    _scrollController.dispose(); // 释放ScrollController
    super.dispose();
  }

  Future<void> _loadBanks() async {
    try {
      // 构建保存数据
      Map<String, dynamic> params = {
        'orgId': '',
      };
      List<Bank> bankList = await ref.read(bankListProvider(params).future);
      setState(() {
        banks = bankList;
        filteredBanks = banks;
      });
    } catch (e) {
      EasyLoading.showError('加载金融机构数据失败');
    }
  }

  void show() {
    setState(() {
      filteredBanks = banks.toList();
      _filterController.clear();
    });
    _showSelectionSheet(context);
  }

  void _showSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              void onBankSelected(Bank? bank) {
                setState(() {
                  selectedBank = bank;
                });
              }

              void onFilterTextChanged(String text) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  setState(() {
                    filteredBanks = banks
                        .where((bank) => bank.name != null && bank.name!.contains(text))
                        .toList();
                  });
                });
              }

              return FractionallySizedBox(
                heightFactor: 0.6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                '选择金融机构',
                                style: TextStyle(color: Color(0xFF000000), fontSize: 16),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.onBankSelected(selectedBank);
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              '确定',
                              style: TextStyle(color: Color(0xFF3B81F2), fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: onFilterTextChanged,
                        controller: _filterController,
                        decoration: InputDecoration(
                          hintText: '请输入金融机构名称',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: Color(0xFFF5F7F9)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: Color(0xFFF5F7F9)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: Color(0xFF5D8FFD)),
                          ),
                          fillColor: const Color(0xFFF5F7F9),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: filteredBanks.length,
                          itemBuilder: (context, index) {
                            final bank = filteredBanks[index];
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                onBankSelected(bank);
                              },
                              onPanStart: (details) {
                                FocusScope.of(context).unfocus();
                              },
                              child: ListTile(
                                title: Text(bank.name ?? '未知'),
                                selected: bank.id == selectedBank?.id,
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // 用于占位符，实际不需要显示任何东西
  }
}