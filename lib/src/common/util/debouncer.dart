import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A utility class for debouncing actions.
///
/// The `DeBouncer` class ensures that a function is executed only after
/// a specified delay, even if it is called multiple times during that period.
/// It is commonly used to handle scenarios like button clicks or text input,
/// where frequent calls need to be throttled.
///
/// Example Usage:
/// ```dart
/// void main() {
///   // Create a DeBouncer instance with a delay of 500 milliseconds.
///   final debouncer = DeBouncer(milliseconds: 500);
///
///   // Simulate a user typing multiple times quickly.
///   for (var i = 0; i < 5; i++) {
///     // Schedule a debounced action for each typing event.
///     debouncer.run(() {
///       print('Debounced Action Executed at: ${DateTime.now()}');
///     });
///   }
///
///   // Cancel the current debounced action before it executes.
///   debouncer.cancel();
///
///   // Clean up the DeBouncer when it's no longer needed.
///   debouncer.dispose();
/// }
/// ```
class DeBouncer {
  /// The delay time in milliseconds for the debounce.
  final int milliseconds;

  /// A Timer object used to delay the execution of actions.
  Timer? _timer;

  /// A class that debounces actions, executing them after a specified delay.
  ///
  /// The [milliseconds] parameter sets the delay in milliseconds (defaults to 500).
  /// Throws an [AssertionError] if [milliseconds] is negative.
  DeBouncer({this.milliseconds = 500}) : assert(milliseconds >= 0, "Milliseconds must be a positive value.");

  /// Attaches the debouncer to a [TextEditingController], triggering [action]
  /// when the text changes, but with a debounce delay.
  void attachToTextController(TextEditingController controller, VoidCallback action) {
    controller.addListener(() {
      run(action);  // Trigger debounce whenever the text changes
    });
  }

  /// Runs the provided action after the specified debounce delay.
  ///
  /// If an action is already scheduled, it cancels it and schedules the new one.
  /// This ensures that only the latest action is executed after the delay.
  ///
  /// - Parameter action: The callback function to execute after the debounce delay.
  void run(VoidCallback action) {
    // Cancel any existing timer to reset the debounce timer.
    _timer?.cancel();

    // Schedule a new timer with the provided delay.
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancels the currently scheduled action, if any.
  ///
  /// This stops the timer and prevents the action from executing.
  void cancel() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }

  /// Checks if the DeBouncer currently has an active timer running.
  ///
  /// Returns `true` if a debounce action is in progress, otherwise `false`.
  bool get isRunning => _timer?.isActive ?? false;

  /// Disposes of the DeBouncer by canceling any active timer
  /// and freeing up resources.
  ///
  /// This method should be called when the DeBouncer is no longer needed.
  void dispose() {
    cancel();
    _timer = null;
  }
}
