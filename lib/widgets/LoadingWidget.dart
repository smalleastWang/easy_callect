import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class LoadingWidget<T> extends StatelessWidget {
  final AsyncValue<T> data;
  final Function(BuildContext context, T value) builder;
  const LoadingWidget({super.key, required this.builder, required this.data});

  @override
  Widget build(BuildContext context) {
    return switch (data) {
      AsyncData(:final value) => builder(context, value),
        AsyncError() => const Text('数据接口调用出错了了错误'),
        _ => Container(
          padding: const EdgeInsets.only(top: 30),
          alignment: Alignment.topCenter,
          child: const CircularProgressIndicator(),
        ),
    };
  }
}