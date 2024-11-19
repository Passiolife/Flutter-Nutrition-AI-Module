import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverlayUtil {
  OverlayEntry? overlayEntry;

  void show({required BuildContext context, required Widget child}) {
    // Remove the existing OverlayEntry.
    remove();

    assert(overlayEntry == null);

    overlayEntry = OverlayEntry(
      builder: (context) {
        return child;
      },
    );

    // Add the OverlayEntry to the Overlay.
    Overlay.of(context, debugRequiredFor: child).insert(overlayEntry!);
  }

  void update() {
    overlayEntry?.markNeedsBuild();
  }

  // Remove the OverlayEntry.
  void remove() {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    overlayEntry = null;
  }
}
