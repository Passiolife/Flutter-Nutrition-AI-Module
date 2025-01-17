import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class OverlayUtil {
  /// Displays the [child] widget over the current UI.
  void show({required BuildContext context, required Widget child});

  /// Removes the currently displayed overlay.
  void remove();

  /// Updates the overlay to rebuild it.
  void update();
}

class OverlayUtilImpl extends OverlayUtil {
  OverlayEntry? overlayEntry;

  @override
  void show({required BuildContext context, required Widget child}) {
    // Ensure that any existing overlay is removed before adding a new one.
    _removeExistingOverlay();

    // Create a new overlay entry.
    overlayEntry = _createOverlayEntry(child);

    // Insert the overlay entry into the overlay.
    _insertOverlay(context: context, child: child);
  }

  @override
  void update() {
    // If the overlay entry exists, mark it as needing a rebuild.
    overlayEntry?.markNeedsBuild();
  }

  // Remove the OverlayEntry.
  @override
  void remove() {
    _removeExistingOverlay();
  }

  // Creates an OverlayEntry for the given widget.
  OverlayEntry _createOverlayEntry(Widget child) {
    return OverlayEntry(
      builder: (context) {
        return child;
      },
    );
  }

  // Inserts the overlay entry into the overlay.
  void _insertOverlay({required BuildContext context, required Widget child}) {
    Overlay.of(context, debugRequiredFor: child).insert(overlayEntry!);
  }

  // Removes the existing overlay entry if it exists.
  void _removeExistingOverlay() {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    overlayEntry = null;
  }
}
