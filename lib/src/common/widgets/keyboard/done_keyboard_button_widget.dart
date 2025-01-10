import 'package:flutter/cupertino.dart';

import '../../extension/context_extension.dart';

class DoneKeyboardButtonWidget extends StatelessWidget {
  const DoneKeyboardButtonWidget({this.onDone, super.key});
  final VoidCallback? onDone;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      right: 0,
      left: 0,
      child: Container(
        width: double.infinity,
        color: const Color(0xFFCAD1D9), //Apple keyboard color
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: CupertinoButton(
              padding: EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
              onPressed: () {
                onDone?.call();
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Text(
                "Done",
                style: TextStyle(
                  color: context.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}