

import 'package:easy_collect/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

showMyModalBottomSheet({required BuildContext context, required WidgetBuilder contentBuilder, required String title}) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48),
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    context.pop();
                  }
                ),
              ],
            ),
            contentBuilder(context),
            SizedBox(height: MediaQuery.of(context).padding.bottom)
          ],
        ),
      );
    },

  );
}


showConfirmModalBottomSheet({required BuildContext context, required WidgetBuilder contentBuilder, required String title, required Function onConfirm, Function? onCancel, EdgeInsetsGeometry? modalPadding}) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: modalPadding ?? const EdgeInsets.symmetric(horizontal: 15),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    if (onCancel != null) {
                      onCancel();
                    }
                    context.pop();
                  }
                ),
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                TextButton(
                  onPressed: () {
                    onConfirm();
                    context.pop();
                  },
                  child: const Text('确定', style: TextStyle(color: MyColors.primaryColor, fontSize: 14)),
                )
              ],
            ),
            contentBuilder(context),
          ],
        ),
      );
    },

  );
}