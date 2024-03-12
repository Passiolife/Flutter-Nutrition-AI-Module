/*
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constant/styles.dart';
import 'context_extension.dart';

void showDialogBox(BuildContext context, String errorMessage) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      if (Platform.isAndroid) {
        return AlertDialog(
          content: Text(
            errorMessage,
            style: AppStyles.style14.copyWith(fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(context.localization?.ok ?? ''),
            )
          ],
        );
      } else {
        return CupertinoAlertDialog(
          content: Text(
            errorMessage,
            style: AppStyles.style14.copyWith(fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(context.localization?.ok ?? ''),
            )
          ],
        );
      }
    },
  );
}
*/
