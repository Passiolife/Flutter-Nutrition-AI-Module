// Overlay management class to encapsulate overlay operations
import 'package:flutter/material.dart';

class OverlayManager {
  OverlayEntry? overlayEntry;

  // Function to show an overlay
  void showOverlay(BuildContext context, Widget child) {
    if (overlayEntry != null) return; // Prevent duplicate overlays
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return child;
    });
    overlayState.insert(overlayEntry!);
  }

  // Function to remove the overlay
  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }
}