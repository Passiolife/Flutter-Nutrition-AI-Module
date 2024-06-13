import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveLoader extends StatelessWidget {
  final double size; // Optional size parameter for the loader
  final Color? color;

  const AdaptiveLoader({
    super.key,
    this.size = 40,
    this.color,
  });

  Color _getDefaultColor(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActivityIndicator(
            radius: size / 2,
            color: color ?? _getDefaultColor(context),
          ) // Use CupertinoActivityIndicator for iOS
        : CircularProgressIndicator(
            color: color ?? _getDefaultColor(context),
            valueColor: AlwaysStoppedAnimation(color),
            value: null,
          ); // Use CircularProgressIndicator for other platforms
  }
}
